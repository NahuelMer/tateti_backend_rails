class PlayersController < ApplicationController

    before_action :set_player, only: [:show, :update, :destroy]
    before_action :check_token, only: [:update, :destroy]

    def create
        @player = Player.new(player_params)
        render_response
    end

    def index
        @player = Player.all
        render status: 200, json: { player: @player }
    end

    def show
        render status: 200, json: { player: @player }
    end

    def update
        @player.assign_attributes(player_params)
        render_response
    end

    def destroy
        if @player.destroy
            render status: 200, json: { message: "El jugador fue eliminado con exito"}
        else
            render_errors_response
        end
    end

    # implementar bcryptjs.compareSync
    def login
        @player = Player.find_by(player_name: params[:player_name], password: params[:password])
        if @player.present?
            render status: 200, json: { player: @player }
        else
            render status: 400, json: { message: "Nombre o contraseña incorrecta" }
        end
    end

    private

    def player_params
        params.require(:player).permit(:player_name, :password)
    end

    def render_response
        if @player.save
            render status: 200, json: { player: @player }
        else
            render_errors_response
        end
    end

    def render_errors_response
        render status: 400, json: { message: @player.errors.details }
    end

    def set_player
        @player = Player.find_by(id: params[:id])
        return if @player.present?
        render status: 404, json: { message: "No se encuentra el jugador #{params[:id]}" }
        false    
    end

    def check_token
        return if request.headers["Authorization"] == @player.token
        render status: 401, json: { message: "Invalid Token" }
        false
    end

end
