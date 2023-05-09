import sqlite3
from flask import Flask, request, g
from flask import Flask, render_template

from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Table
from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Table, Paragraph, Image
from reportlab.platypus.tables import TableStyle
from reportlab.lib.styles import getSampleStyleSheet
from flask import send_file

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
    db = get_db()
    cursor = db.cursor()

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
        for i in range(len(item_names)):
            item_name = item_names[i]
            quantity_as_number = quantities_as_number[i]
            quantity_as_weight = quantities_as_weight[i]
            notes = notes_list[i]

            cursor.execute('INSERT INTO InventoryFlowInOut (ItemName, QuantityAsNumber, QuantityAsWeight, Date, Time, InventoryName, FlowType, SourceOrDestination, Notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
                            (item_name, quantity_as_number, quantity_as_weight, date, time, inventory_name, flow_type, source_or_destination, notes))

        db.commit()

        # Retrieve inserted data from database
        cursor.execute('SELECT * FROM InventoryFlowInOut ORDER BY FlowID DESC LIMIT ?', (len(item_names),))
        inserted_data = cursor.fetchall()
    else:
        inserted_data = None

    # Retrieve list of item names from database
    cursor.execute('SELECT DISTINCT [ItemName] FROM Item_old')
    item_names = [row[0] for row in cursor.fetchall()]

    return render_template('form1 copy 2last.html', inserted_data=inserted_data, item_names=item_names)
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Table, Paragraph
from reportlab.lib.styles import getSampleStyleSheet




from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import Image, Paragraph, SimpleDocTemplate, Table, TableStyle
from flask import send_file

@app.route('/print-pdf')
def print_pdf():
    db = get_db()
    cursor = db.cursor()

    # Get data from database
    cursor.execute('SELECT * FROM InventoryFlowInOut ORDER BY FlowID DESC')
    data = cursor.fetchall()

    # Add headers to data
    headers = ['Item Name', 'Quantity (Number)', 'Quantity (Weight)', 'Date', 'Time', 'Inventory Name', 'Flow Type', 'Source/Destination', 'Notes']
    data.insert(0, headers)

    # Create PDF
    pdf = SimpleDocTemplate('output.pdf', pagesize=letter)
    elements = []

    # Add logo
    logo = Image('logo.png', width=100, height=100)
    elements.append(logo)

    # Add company name
    styles = getSampleStyleSheet()
    elements.append(Paragraph('Company Name', styles['Heading1']))

    # Add some text
    elements.append(Paragraph('This is some text.', styles['Normal']))

    # Add table
    table = Table(data)
    elements.append(table)

    # Apply formatting to table
    table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.grey),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 14),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
        ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
        ('GRID', (0, 0), (-1, -1), 1, colors.black),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkgrey),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('TEXTCOLOR', (0, 1), (-1, -1), colors.black),
        ('BACKGROUND', (0, 1), (-1, 1), colors.lightgrey),
        ('FONTNAME', (0, 1), (-1, 1), 'Helvetica-Bold'),
        ('ALIGN', (0, 1), (-1, 1), 'CENTER'),
        ('ALIGN', (0, 0), (-1, 0), 'CENTER'),
        ('TOPPADDING', (0, 0), (-1, 0), 10),
        ('BOTTOMPADDING', (0, 1), (-1, 1), 10),
        ('LEFTPADDING', (0, 0), (-1, -1), 8),
        ('RIGHTPADDING', (0, 0), (-1, -1), 8),
    ]))

    pdf.build(elements)

    # Send PDF to user
    return send_file('output.pdf', as_attachment=True)
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