class BoardPlayer < ApplicationRecord

    validates :chip, presence: true

    belongs_to :board
    belongs_to :player
end
