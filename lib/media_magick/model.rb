require 'active_support/concern'
require 'carrierwave/mongoid'
require 'media_magick/attachment_uploader'

module MediaMagick
  module Model
    extend ActiveSupport::Concern

    module ClassMethods
      def attaches_many(name, options = {})
        attaches_block = block_given? ? Proc.new : nil

        name_camelcase = create_attaches_class(name, options, attaches_block) do
          create_video_methods(name) if options[:allow_videos]

          field :priority, type: Integer, default: 0

          default_scope asc(:priority)

          embedded_in(:attachmentable, polymorphic: true)
        end

        embeds_many(name, :as => :attachmentable, class_name: "#{self}#{name_camelcase}")
      end

      def attaches_one(name, options = {})
        attaches_block = block_given? ? Proc.new : nil

        name_camelcase = create_attaches_class(name, options, attaches_block) do
          create_video_methods(name) if options[:allow_videos]

          embedded_in(name)
        end

        embeds_one(name, class_name: "#{self}#{name_camelcase}", cascade_callbacks: true)
      end

      private

      def create_attaches_class(name, options, attaches_block, &block)
        klass = Class.new do
          include Mongoid::Document
          extend CarrierWave::Mount

          field :type, type: String, default: options[:as] || 'image'

          def self.create_video_methods(name)
            field :video, type: String

            def video=(url)
              self.type = 'video'
              super

              require 'net/http'

              id = url.match(/youtube.com\/watch\?v=(.*)/)[1]

              Net::HTTP.start( 'img.youtube.com' ) { |http|
                resp = http.get( "/vi/#{id}/0.jpg" )

                open( "/tmp/#{id}.jpg", 'wb' ) { |file|
                  file.write(resp.body)
                }
              }

              photos_and_video.store!(File.new("/tmp/#{id}.jpg"))
            end

            def source(options = {})
              id = video.match(/youtube.com\/watch\?v=(.*)/)[1]
              "<iframe width=\"#{ options[:width] || 560}\" height=\"#{ options[:height] || 315 }\" src=\"http://www.youtube.com/embed/#{id}\" frameborder=\"0\" allowfullscreen></iframe>"
            end
          end

          class_eval(&block) if block_given?

          mount_uploader name.to_s.singularize, (options[:uploader] || AttachmentUploader)

          self.const_set "TYPE", options[:type] || :image
          self.const_set "ATTACHMENT", name.to_s.singularize

          class_eval(&attaches_block) if attaches_block

          def method_missing(method, args = nil)
            return self.send(self.class::ATTACHMENT).file.filename if method == :filename
            self.send(self.class::ATTACHMENT).send(method)
          end
        end

        name_camelcase = name.to_s.camelcase
        Object.const_set "#{self}#{name_camelcase}", klass

        return name_camelcase
      end
    end
  end
end
