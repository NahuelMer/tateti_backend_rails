class Board < ApplicationRecord
    before_create :set_token

    validates :turn_name, presence: true
    validates :turn_counter, presence: true
    validates :cells, presence: true
    validates :token, uniqueness: true

    def set_token
        self.token = SecureRandom.uuid
    end

end
