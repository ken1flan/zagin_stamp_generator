require 'rom-repository'

class ImageHistoryRepo < ROM::Repository[:image_histories]
  commands :create, update: :by_pk, delete: :by_pk

  def query(condition)
    image_histories.where(condition).as(ImageHistory)
  end
end
