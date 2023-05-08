
from flask import Flask, render_template, request, url_for, redirect
import sqlite3
app = Flask(__name__)
@app.route('/InventoryItem')
def inventory_item():
    conn = sqlite3.connect('lastcahncemydarli.db')
    c = conn.cursor()
    c.execute('SELECT * FROM InventoryItem')
    inventory_rows = c.fetchall()
    c.execute('SELECT * FROM Transfer')
    transfer_rows = c.fetchall()
    conn.close()
    return render_template('InventoryItem.html', inventory_rows=inventory_rows, transfer_rows=transfer_rows)


# Route for the Transfer table page that displays the table data and includes a form for adding a new row
@app.route('/transfer', methods=['GET', 'POST'])
def transfer():
    # Connect to the database
    conn = sqlite3.connect('lastcahncemydarli.db')
    c = conn.cursor()

    # If the request method is POST, insert the new row into the Transfer table
    if request.method == 'POST':
        #today
        date= request.form['date']
        time = request.form['time']
        quantity = request.form['quantity']
        item_id = request.form['item_id']
        source_inventory_id = request.form['source_inventory_id']
        destination_inventory_id = request.form['destination_inventory_id']
        c.execute("INSERT INTO Transfer (Date, Time, Quantity,  ItemName, SourceInventoryName, DestinationInventoryName) VALUES (?, ?, ?, ?, ?, ?)",
                  (date, time, quantity, item_id, source_inventory_id, destination_inventory_id))
        conn.commit()
        conn.close()
        return 'Data inserted into Transfer table successfully.'

    # If the request method is GET, retrieve the existing data from the Transfer table and render the HTML template
    else:
        c.execute("SELECT * FROM Transfer")
        transfer_data = c.fetchall()
        conn.close()
        return render_template('transfer.html', transfer_data=transfer_data)

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