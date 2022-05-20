class Player < ApplicationRecord
    # USAR BCRYPT CON EL PASS
    before_create :set_token

    validates :player_name, presence: true
    validates :password, presence: true
    validates :token, uniqueness: true

    has_many :board_players, dependent: :destroy
    has_many :boards, through: :board_players

    def set_token
        self.token = SecureRandom.uuid
    end

end
