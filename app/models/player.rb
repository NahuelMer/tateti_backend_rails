class Player < ApplicationRecord
    before_create :set_token

    validates :player_name, presence: true
    validates :token, uniqueness: true

    def set_token
        self.token = SecureRandom.uuid
    end

end
