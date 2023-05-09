import sqlite3
from flask import Flask, request, g
from flask import Flask, render_template
app = Flask(__name__)

DATABASE = 'lastcahncemydarli.db'

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
        db.execute("PRAGMA foreign_keys = ON")
    return db

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    return db

@app.route('/')
def index():
    return render_template('form.html')

@app.route('/insert', methods=['GET', 'POST'])
def insert():
    if request.method == 'POST':
        # Retrieve data from all sets of fields
        item_names = request.form.getlist('item_name')
        quantities_as_number = request.form.getlist('quantity_as_number')
        quantities_as_weight = request.form.getlist('quantity_as_weight')
        notes_list = request.form.getlist('notes')
        date = request.form['date']
        time = request.form['time']
        flow_type = request.form['flow_type']
        source_or_destination = request.form['source_or_destination']
        inventory_name = request.form['inventory_name']

        # Insert data into database
        db = get_db()
        cursor = db.cursor()

        for i in range(len(item_names)):
            item_name = item_names[i]
            quantity_as_number = quantities_as_number[i]
            quantity_as_weight = quantities_as_weight[i]
            notes = notes_list[i]

            cursor.execute('INSERT INTO InventoryFlowInOut (ItemName, QuantityAsNumber, QuantityAsWeight, Date, Time, InventoryName, FlowType, SourceOrDestination, Notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
                            (item_name, quantity_as_number, quantity_as_weight, date, time, inventory_name, flow_type, source_or_destination, notes))

        db.commit()

        return 'Data inserted successfully!'
    else:
        return render_template('form1 copy.html')



if __name__ == '__main__':
    app.run(debug=True)

# from flask import Flask, render_template, request
# import sqlite3

# app = Flask(__name__)

# # Route for the InventoryItem page that displays the table data and includes a form for adding a new row
# @app.route('/InventoryItem', methods=['GET', 'POST'])
# def inventory_item():
#     # Connect to the database
#     conn = sqlite3.connect('database.db')
#     c = conn.cursor()

#     # If the request method is POST, insert the new rows into the InventoryItem and Transfer tables
#     if request.method == 'POST':
#         item_name = request.form['item_name']
#         quantity = int(request.form['quantity'])
#         c.execute("INSERT INTO InventoryItem (ItemName, Quantity) VALUES (?, ?)", (item_name, quantity))

#         # Retrieve the last inserted row ID from the InventoryItem table
#         c.execute("SELECT last_insert_rowid()")
#         item_id = c.fetchone()[0]

#         date = request.form['date']
#         time = request.form['time']
#         transfer_quantity = int(request.form['transfer_quantity'])
#         source_inventory_id = int(request.form['source_inventory_id'])
#         destination_inventory_id = int(request.form['destination_inventory_id'])
#         c.execute("INSERT INTO Transfer (Date, Time, Quantity, ItemID, SourceInventoryID, DestinationInventoryID) VALUES (?, ?, ?, ?, ?, ?)",
#                   (date, time, transfer_quantity, item_id, source_inventory_id, destination_inventory_id))

#         conn.commit()
#         conn.close()
#         return 'Data inserted into InventoryItem and Transfer tables successfully.'

#     # If the request method is GET, retrieve the existing data from the InventoryItem and Transfer tables and render the HTML template
#     else:
#         c.execute("SELECT * FROM InventoryItemView")
#         item_data = c.fetchall()
#         c.execute("SELECT * FROM Transfer")
#         transfer_data = c.fetchall()
#         conn.close()
#         return render_template('InventoryItem.html', item_data=item_data, transfer_data=transfer_data)

# if __name__ == '__main__':
#     app.run(debug=True)