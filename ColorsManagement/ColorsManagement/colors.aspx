<%@ Page Language="VB" AutoEventWireup="false" CodeBehind="colors.aspx.vb" Inherits="ColorsManagement.Colors" %>

<!DOCTYPE html>
<html dir="rtl">
<head>
    <title>ניהול צבעים</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    <style>
        /* הגדרת רוחב אחיד לכל השדות */
        input[type="text"], input[type="number"] {
            width: 100px;
            margin-bottom: 10px;
        }

        /* קביעת גופן David לכל התוכן בעמוד */
        body {
            font-family: 'David', sans-serif;
        }

        /* עיצוב הכפתור "עדכן" */
        .update-btn {
            background-color: #4169E1; /* צבע תכלת */
            color: #FFFFFF; /* צבע טקסט לבן */
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            display: inline-flex;
            align-items: center;
        }

        .update-btn i {
            margin-left: 8px; /* רווח בין האייקון לטקסט */
        }

        /* עיצוב הכפתור "חדש" */
        .new-btn {
            background-color: #006400; /* צבע ירוק */
            color: #FFFFFF; /* צבע טקסט לבן */
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            display: inline-flex;
            align-items: center;
        }

        .new-btn i {
            margin-left: 8px; /* רווח בין האייקון לטקסט */
        }

        /* אפקט כפתור במעבר עכבר */
        button:hover {
            opacity: 0.8;
        }

        .required {
            color: red;
            font-weight: bold;
        }

        #colorsTable {
            width: 100%;  /* הגדרת רוחב הטבלה ל-100% */
            table-layout: fixed;  /* שימוש בסגנון Fixed להבטחת אחידות בגודל העמודות */
        }

        #colorsTable th, #colorsTable td {
            word-wrap: break-word;  /* מאפשר חיתוך טקסט אם הוא ארוך מדי */
            padding: 8px;  /* מרווחים בין התוכן של תא לטבלה */
            text-align: center;  /* יישור התוכן לאמצע */
        }
    </style>
</head>
<body>
    <h1>טבלת צבעים</h1>
    <!-- שדה hidden לשמירת ה-ID -->
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
    // שליפת הטוקן
    function getAuthToken() {
        return sessionStorage.getItem('authToken'); // טוקן שנשמר ב-sessionStorage
    }

    // פונקציה לעדכון צבע
    function updateColor() {
        var colorID = $("#colorID").val();
        var colorName = $("#colorName").val().trim();
        var price = $("#price").val().trim();
        var displayOrder = $("#displayOrder").val();
        var inStock = $("#inStock").is(":checked");

        // בדיקה אם השדות החובה (שם הצבע ומחיר) ריקים
        if (!colorName) {
            alert("חובה למלא את שם הצבע.");
            return;
        }

        if (!price) {
            alert("חובה למלא את המחיר.");
            return;
        }

        // הוספת בדיקה אם המחיר הוא ערך מספרי תקין
        if (isNaN(price) || price <= 0) {
            alert("יש להזין מחיר תקין (מספר חיובי).");
            return;
        }

        // בדיקת שדה סדר הצגה (אופציונלי אך אם קיים, צריך להיות מספר תקין)
        if (displayOrder && (isNaN(displayOrder) || displayOrder < 0)) {
            alert("סדר הצגה צריך להיות מספר חיובי או אפס.");
            return;
        }

        // שליחת הבקשה עם הטוקן
        $.ajax({
            type: "POST",
            url: "Colors.aspx/UpdateColor",
            headers: {
                'Authorization': 'Bearer ' + getAuthToken()  // הוספת הטוקן לכותרת
            },
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
                console.log("Color updated successfully", response);
                loadColors(); // טען מחדש את הצבעים
            },
            error: function (err) {
                console.log("Error updating color:", err);
                alert("שגיאה בעדכון הצבע");
            }
        });
    }

    // פונקציה לטעינת הצבעים מתוך השרת
    function loadColors() {
        $.ajax({
            type: "GET",
            url: "Colors.aspx/GetColors",
            headers: {
                'Authorization': 'Bearer ' + getAuthToken()  // הוספת הטוקן לכותרת
            },
            success: function (response) {
                var tableBody = $("#colorsTable tbody");
                tableBody.empty(); // ננקה את התוכן הקיים

                for (var i = 0; i < response.length; i++) {
                    var color = response[i];
                    var row = "<tr id='row_" + color.ID + "'>" +
                        "<td>" + color.ColorName + "</td>" +
                        "<td>" + color.Price + "</td>" +
                        "<td>" + color.DisplayOrder + "</td>" +
                        "<td>" + (color.InStock ? 'כן' : 'לא') + "</td>" +
                        "<td><button onclick='editColor(" + color.ID + ", \"" + color.ColorName + "\", " + color.Price + ", " + color.DisplayOrder + ", " + color.InStock + ")'>ערוך</button> " +
                        "<button onclick='deleteColor(" + color.ID + ")'>מחק</button></td>" +
                        "</tr>";
                    tableBody.append(row);
                }
            },
            error: function (err) {
                console.log("Error loading colors:", err);
                alert("שגיאה בטעינת הצבעים");
            }
        });
    }

    // פונקציה למחיקת צבע
    function deleteColor(colorID) {
        if (confirm("האם אתה בטוח שברצונך למחוק את הצבע הזה?")) {
            $.ajax({
                type: "POST",
                url: "Colors.aspx/DeleteColor",
                headers: {
                    'Authorization': 'Bearer ' + getAuthToken()  // הוספת הטוקן לכותרת
                },
                data: JSON.stringify({ colorID: colorID }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log("Color deleted successfully");
                    loadColors();  // טען מחדש את הטבלה
                },
                error: function (err) {
                    console.error("Error deleting color:", err);
                    alert("שגיאה במחיקת הצבע");
                }
            });
        }
    }

    // פונקציה לעריכת צבע
    function editColor(id, color, price, displayOrder, inStock) {
        $("#colorID").val(id);
        $("#colorName").val(color);
        $("#price").val(price);
        $("#displayOrder").val(displayOrder);
        $("#inStock").prop("checked", inStock);
    }

    // פונקציה לניקוי השדות
    function clearFields() {
        $("#colorID").val('');
        $("#colorName").val('');
        $("#price").val('');
        $("#displayOrder").val('');
        $("#inStock").prop("checked", false);
    }

    // פונקציה לגרירת שורות
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

    // עדכון סדר הצגה בבסיס הנתונים
    function updateDisplayOrderInDB(newOrder) {
        $.ajax({
            type: "POST",
            url: "Colors.aspx/updateDisplayOrderInB",
            headers: {
                'Authorization': 'Bearer ' + getAuthToken()  // הוספת הטוקן לכותרת
            },
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
</script>
</body>
</html>
