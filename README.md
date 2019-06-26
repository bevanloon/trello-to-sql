Quick and dirty ruby api interaction with Trello to persist cards for a table into a sqlite3 database file.

## Usage

You will need a Trello [key and token](https://trello.com/app-key). These should be set as ENV vars and called `TRELLO_KEY` and `TRELLO_TOKEN` respectively.

You can invoke the app from the command line:

`TRELLO_KEY=your_key TRELLO_TOKEN=your_token ruby grab.rb <command> <option>`

### Commands

#### `ruby grab.rb boards`

List the boards you are member of, showing the `id` and `name` of each board. Note you do not need an `<option>` to list the boards.

#### `ruby grab.rb board board_id`

Output information for the board identified by `board_id` as a json payload.

#### `ruby grab.rb cards board_id`

Output information about the cards associated with the board identified by `board_id`.

#### `ruby grab.rb savecards board_id`

This is the real reason for the script. This persists the title and description of each card into a sqlite3 database. The database will be called `trello_cards.db`. The database will contain a single table called `cards` which has two columns `title` and `description`.

## Dependencies

Relies on `faraday` and `sqlite3`. You should be able to `bundle` to install these.

## Limitations

Trello imposes some [rate limiting on api
calls](https://help.trello.com/article/838-api-rate-limits). This is not handled at the
moment.

If your board has more than 1000 cards, the Trello API expects you to [page
through the
results](https://developers.trello.com/docs/api-introduction#section-paging). This is not implemented.
