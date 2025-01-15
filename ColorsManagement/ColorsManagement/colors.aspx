<%@ Page Language="VB" AutoEventWireup="false" CodeBehind="colors.aspx.vb" Inherits="ColorsManagement.Colors" %>

<!DOCTYPE html>
<html dir="rtl">
<head>
    <title>ניהול צבעים</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    <style>
       
        input[type="text"], input[type="number"] {
            width: 100px;
            margin-bottom: 10px;
        }

    
        body {
            font-family: 'David', sans-serif;
        }

        .update-btn {
            background-color: #4169E1; 
            color: #FFFFFF; 
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            display: inline-flex;
            align-items: center;
        }

        .update-btn i {
            margin-left: 8px;
        }

        .new-btn {
            background-color: #006400; 
            color: #FFFFFF; 
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            display: inline-flex;
            align-items: center;
        }

        .new-btn i {
            margin-left: 8px; 
        }

        button:hover {
            opacity: 0.8;
        }

        .required {
            color: red;
            font-weight: bold;
        }

        #colorsTable {
            width: 100%; 
            table-layout: fixed;  
        }

        #colorsTable th, #colorsTable td {
            word-wrap: break-word;  
            padding: 8px;  
            text-align: center; 
        }
    </style>
</head>
<body>
    <h1>טבלת צבעים</h1>
    <input type="hidden" id="colorID" />

    <table id="colorsTable" border="1">
        <thead>
            <tr>
                <th>שם הצבע</th>
                <th>מחיר</th>
                <th>סדר הצגה</th>
                <th>האם במלאי</th>
                <th>פעולה</th>
            </tr>
        </thead>
        <tbody>
            <!-- צבעים יוצגו כאן -->
        </tbody>
    </table>

    <div style="background-color: #f0f0f0; padding: 20px; border-radius: 5px;">
        <h3>ערכים</h3>
        <div>
            <label for="colorName"><span class="required">*</span> שם הצבע:</label>
            <input type="text" id="colorName" />
        </div>
        <div>
            <label for="price"><span class="required">*</span> מחיר:</label>
            <input type="text" id="price" />
        </div>
        <div>
            <label for="displayOrder">סדר הצגה:</label>
            <input type="number" id="displayOrder" />
        </div>
        <div>
            <label for="inStock">האם הצבע במלאי:</label>
            <input type="checkbox" id="inStock" />
        </div>

        <div>
            <button class="update-btn" onclick="updateColor()">
                📝 עדכן
            </button>
            <button class="new-btn" onclick="clearFields()">
                <i class="fas fa-plus"></i> חדש
            </button>
        </div>
    </div>

<script type="text/javascript">
    function getAuthToken() {
        return sessionStorage.getItem('authToken'); 
    }

    function updateColor() {
        var colorID = $("#colorID").val();
        var colorName = $("#colorName").val().trim();
        var price = $("#price").val().trim();
        var displayOrder = $("#displayOrder").val();
        var inStock = $("#inStock").is(":checked");

        if (!colorName || !price) {
            alert("חובה למלא את שם הצבע והמחיר.");
            return;
        }

        if (isNaN(price) || price <= 0) {
            alert("המחיר חייב להיות מספר חיובי.");
            return;
        }

        $.ajax({
            type: "POST",
            url: "Colors.aspx/UpdateColor",
            data: JSON.stringify({
                colorID: colorID,
                colorName: colorName,
                price: price,
                displayOrder: displayOrder,
                inStock: inStock
            }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d) {
                    alert("הצבע עודכן בהצלחה.");
                    loadColors();  
                } else {
                    alert("הייתה בעיה בעדכון הצבע.");
                }
            },
            error: function (err) {
                alert("שגיאה בעדכון הצבע.");
            }
        });
    }

    function deleteColor(colorID) {
        if (confirm("האם אתה בטוח שברצונך למחוק את הצבע הזה?")) {
            $.ajax({
                type: "POST",
                url: "Colors.aspx/DeleteColor",
                data: JSON.stringify({ colorID: colorID }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    alert(response.d); 
                    loadColors(); 
                },
                error: function (err) {
                    alert("שגיאה במחיקת הצבע.");
                }
            });
        }
    }

    function editColor(id, color, price, displayOrder, inStock) {
        $("#colorID").val(id); 
        console.log("Editing color ID: " + id);  
        $("#colorName").val(color);
        $("#price").val(price);
        $("#displayOrder").val(displayOrder);
        $("#inStock").prop("checked", inStock);
    }

    function clearFields() {
        $("#colorID").val('');
        $("#colorName").val('');
        $("#price").val('');
        $("#displayOrder").val('');
        $("#inStock").prop("checked", false);
    }

    $(document).ready(function () {
        loadColors();
        $("#colorsTable tbody").sortable({
            update: function (event, ui) {
                var newOrder = $(this).sortable('toArray').map(function (rowId) {
                    return rowId.replace("row_", "");
                });
                updateDisplayOrderInDB(newOrder);
            }
        });
    });

    function updateDisplayOrderInDB(newOrder) {
        $.ajax({
            type: "POST",
            url: "Colors.aspx/UpdateDisplayOrderInDB",
            data: JSON.stringify({ newOrder: newOrder }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                console.log("Display order updated");
            },
            error: function (err) {
                console.log("Error updating display order:", err);
                alert("שגיאה בעדכון סדר הצגה");
            }
        });
    }

    function loadColors() {
     
        $.ajax({
            type: "GET",
            url: "Colors.aspx/GetColors",
            headers: {
                'Authorization': 'Bearer ' + getAuthToken()  
            },
            success: function (response) {
                var tableBody = $("#colorsTable tbody");
                tableBody.empty(); 

                if (response.d.length === 0) {
                    tableBody.append("<tr><td colspan='5'>לא נמצאו צבעים</td></tr>");
                    return;
                }

                $.each(response.d, function (index, color) {
                    var row = $("<tr id='row_" + color.ColorID + "'>");
                    row.append("<td>" + color.ColorName + "</td>");
                    row.append("<td>" + color.Price + "</td>");
                    row.append("<td>" + color.DisplayOrder + "</td>");
                    row.append("<td>" + (color.InStock ? "כן" : "לא") + "</td>");
                    row.append("<td><button onclick='editColor(" + color.ColorID + ", \"" + color.ColorName + "\", \"" + color.Price + "\", " + color.DisplayOrder + ", " + color.InStock + ")'>ערוך</button><button onclick='deleteColor(" + color.ColorID + ")'>מחק</button></td>");
                    tableBody.append(row);
                });
            },
            error: function (err) {
                alert("שגיאה בטעינת הצבעים.");
            }
        });
    }
</script>

</body>
</html>
