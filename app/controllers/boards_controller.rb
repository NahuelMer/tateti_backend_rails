class BoardsController < ApplicationController

    before_action :set_board, only: [:show, :update, :destroy]
    before_action :search_board_by_code, only: [:join]
    before_action :check_token, only: [:update, :destroy]
    before_action :check_turn, only: [:update]
    before_action :check_game_ended, only: [:update]
    before_action :check_empty_cell, only: [:update]

    # Crea el tablero y devuelve sus datos incluyendo token y codigo de la sala
    def create
        @board = Board.new()

        if @board.save
            @board_player = BoardPlayer.find_or_initialize_by(chip: "X", board_id: @board.id, player_id: params[:player_id])
            if @board_player.persisted?
                render status: 200, json: { message: "La partida ya fue creada" }
            elsif @board_player.save
                render status: 200, json: { board: @board }
            else
                render status: 400, json: { message: @board_player.errors.details }
            end
        else
            render_errors_response
        end

        
    end

    # Devuelve el tablero buscado incluyendo el estado de sus celdas
    def show
        render status: 200, json: { board: @board }
    end

    # Devuelve todos los tableros
    def index
        @board = Board.all
        render status: 200, json: { boards: @board }
    end

    # Permite que un jugador se una a un tablero ya creado por otro jugador
    def join
        @board_player = BoardPlayer.find_or_initialize_by(chip: "O", board_id: @board.id, player_id: params[:player_id])

        if @board_player.persisted?
            render status: 200, json: { message: "El jugador ya se unio a la partida" }
        elsif @board_player.save
            render status: 200, json: { board_player: @board_player }
        else
            render status: 400, json: { message: @board_player.errors.details }
        end
    end

    # Recibe el movimiento ( fila, celda y jugador ), verifica si hay un ganador o un empate y actualiza el tablero
    def update

        def current_turn = @board_player.chip

        @board.assign_attributes(turn_name: @board_player.chip == "X" ? "O" : "X")

        @board.assign_attributes(turn_counter: @board.turn_counter + 1)

        @board.cells[params[:row]][params[:cell]] = current_turn

        if @board.turn_counter == 9
            render_draw_response
        else
            check_win
        end

    end

    # Elimina el tablero
    def destroy
        if @board.destroy
            render status: 200, json: { message: "El tablero ha sido eliminado" }
        else
            render_errors_response
        end
    end

    private

    def render_response
        if @board.save
            render status: 200, json: { board: @board }
        else
            render_errors_response
        end
    end

    def render_errors_response
        render status: 400, json: { message: @board.errors.details }
    end

    def set_board
        @board = Board.find_by(id: params[:id])
        return if @board.present?
        render status: 404, json: { message: "No se encuentra el tablero #{params[:id]}" }
        false    
    end

    # Busca el tablero con el codigo de la sala
    def search_board_by_code
        @board = Board.find_by(board_code: params[:board_code])
        return if @board.present?
        render status: 404, json: { message: "No se encuentra el tablero #{params[:board_code]}" }
        false  
    end

    # Verifica que sea el turno del jugador que realizo la jugada
    def check_turn

        @board_player = BoardPlayer.find_by(board_id: @board.id, player_id: params[:player_id])
        if @board_player.persisted?
            return if @board.turn_name == @board_player.chip
            render status: 400, json: { message: "Debes esperar a que sea tu turno" }
            false
        else
            render status: 400, json: { message: @board_player.errors.details }
        end

    end

    # Verifica que no se hagan movimientos si la partida ya finalizo
    def check_game_ended
        return if @board.game_ended == false
        render status: 400, json: { message: "El juego ya ha terminado" }
        false
    end

    # Verifica que no se hagan movimientos en una celda ya ocupada
    def check_empty_cell
        return if @board.cells[params[:row]][params[:cell]] == "" || @board.cells[params[:row]][params[:cell]] == nil
        render status: 400, json: { message: "La celda ya se encuentra ocupada" }
        false
    end

    # Verifica si hay un ganador controlando el valor actual de las celdas
    def check_win
        if @board.cells["0"]["0"] == current_turn && @board.cells["1"]["1"] == current_turn && @board.cells["2"]["2"] == current_turn
            render_endgame_response

        elsif @board.cells["0"]["2"] == current_turn && @board.cells["1"]["1"] == current_turn && @board.cells["2"]["0"] == current_turn
            render_endgame_response

        elsif @board.cells["0"]["0"] == current_turn && @board.cells["0"]["1"] == current_turn && @board.cells["0"]["2"] == current_turn
            render_endgame_response

        elsif @board.cells["1"]["0"] == current_turn && @board.cells["1"]["1"] == current_turn && @board.cells["1"]["2"] == current_turn
            render_endgame_response

        elsif @board.cells["2"]["0"] == current_turn && @board.cells["2"]["1"] == current_turn && @board.cells["2"]["2"] == current_turn
            render_endgame_response

        elsif @board.cells["0"]["0"] == current_turn && @board.cells["1"]["0"] == current_turn && @board.cells["2"]["0"] == current_turn
            render_endgame_response

        elsif @board.cells["0"]["1"] == current_turn && @board.cells["1"]["1"] == current_turn && @board.cells["2"]["1"] == current_turn
            render_endgame_response

        elsif @board.cells["0"]["2"] == current_turn && @board.cells["1"]["2"] == current_turn && @board.cells["2"]["2"] == current_turn
            render_endgame_response

        else
            render_response
        end

    end

    def render_draw_response 

        @board.assign_attributes(game_ended: true)

        if @board.save
            render status: 200, json: { message: "El juego termino en empate" }
        else
            render_errors_response
        end

    end

    def render_endgame_response

        @board.assign_attributes(game_ended: true)

        if @board.save
            render status: 200, json: { message: "El juego ha terminado, el ganador es: #{current_turn}" }
        else
            render_errors_response
        end
    end

    def check_token
        return if request.headers["Authorization"] == "Bearer #{@board.token}"
        render status: 401, json: { message: "Invalid Token" }
        false
    end

end
