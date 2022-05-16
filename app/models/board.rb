class Board < ApplicationRecord
    before_create :set_token
    before_create :set_board_code

    validates :turn_name, presence: true
    validates :turn_counter, presence: true
    validates :cells, presence: true
    validates :board_code, uniqueness: true
    validates :token, uniqueness: true

    has_many :board_players, dependent: :destroy
    has_many :players, through: :board_players

    def set_board_code
        self.board_code = SecureRandom.random_number(1000...9999)
    end

    def set_token
        self.token = SecureRandom.uuid
    end

end
