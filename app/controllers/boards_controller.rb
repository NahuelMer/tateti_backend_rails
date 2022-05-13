class BoardsController < ApplicationController

    # Recordatorio: comentar todo al terminar
    # TODO: verificar token al unirse al tablero (o poner un codigo) - implementar tokens - hacer que la logica funcione con los players

    before_action :set_board, only: [:show, :update, :destroy, :join]
    # before_action :check_token, only: [:update, :destroy] (quiza el join iria aca tambien)
    before_action :check_turn, only: [:update]
    before_action :check_game_ended, only: [:update]
    before_action :check_empty_cell, only: [:update]

    # Inicializa el tablero y tira el token de la sala
    def create
        @board = Board.new()

        if @board.save
            @board_player = BoardPlayer.find_or_initialize_by(board_id: @board.id, player_id: params[:player_id])
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

    # Devuelve el estado del tablero
    def show
        render status: 200, json: { board: @board }
    end

    # El segundo jugador se une al tablero
    def join
        @board_player = BoardPlayer.find_or_initialize_by(board_id: @board.id, player_id: params[:player_id])

        if @board_player.persisted?
            render status: 200, json: { message: "El jugador ya se unio a la partida" }
        elsif @board_player.save
            render status: 200, json: { board_player: @board_player }
        else
            render status: 400, json: { message: @board_player.errors.details }
        end
    end

    # Recibe el movimiento y actualiza el tablero (tambien finaliza la partida)
    def update

        # verifica el token, luego el turn_name que sea correcto y asigna los valores al tablero(con un row y cell)

        def current_turn = params[:turn_name] # probar solo con params en la verifiicaion

        @board.assign_attributes(turn_name: @board.turn_name == "X" ? "O" : "X")

        @board.assign_attributes(turn_counter: @board.turn_counter + 1)

        @board.cells[params[:row]][params[:cell]] = params[:turn_name]
        puts @board.cells[params[:row]][params[:cell]]


        if @board.turn_counter == 8
            check_draw
        else
            check_win
        end
 
    end

    # Reinicia la partida eliminando el board
    def destroy
        if @board.destroy
            render status: 200, json: { message: "El tablero ha sido eliminado" }
        else
            render_errors_response
        end
    end

    private

    def board_params
        params.require(:board).permit(:cells, :game_ended, :turn_name, :turn_counter)
    end

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

    def check_turn
        return if @board.turn_name == params[:turn_name]
        render status: 400, json: { message: "Debes esperar a que sea tu turno" }
        false
    end

    def check_game_ended
        return if @board.game_ended == false
        render status: 400, json: { message: "El juego ya ha terminado" }
        false
    end

    def check_empty_cell
        return if @board.cells[params[:row]][params[:cell]] == "" || @board.cells[params[:row]][params[:cell]] == nil
        render status: 400, json: { message: "La celda ya se encuentra ocupada" }
        false
    end

    # funciona pero lo hace en el sigiuente movimiento - switch case?
    # probar con que esta funcion devuelva un true o false y que arriba en un if depediendo de la respuesta vaya a cada render
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

    def check_draw 

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
        return if request.headers["Authorization"] == @board.token
        render status: 401, json: { message: "Invalid Token" }
        false
    end

end
