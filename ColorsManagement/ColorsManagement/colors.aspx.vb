Imports System.Data.SqlClient

Partial Class Colors
    Inherits System.Web.UI.Page

    Dim connString As String = "Data Source=localhost;Initial Catalog=colorManagement;Integrated Security=True"
    Dim conn As New SqlConnection(connString)

    ' עדכון צבע
    <System.Web.Services.WebMethod()>
    Public Shared Sub UpdateColor(ByVal colorID As Integer, ByVal colorName As String, ByVal price As Decimal, ByVal displayOrder As Integer, ByVal inStock As Boolean)
        Try
            If String.IsNullOrEmpty(colorName) OrElse price <= 0 OrElse displayOrder <= 0 Then
                Throw New Exception("שדות לא הוזנו כראוי.")
            End If

            Dim query As String = "UPDATE Colors SET Color = @Color, Price = @Price, DisplayOrder = @DisplayOrder, ColorInStock = @ColorInStock WHERE ID = @ColorID"
            Using conn As New SqlConnection("Data Source=localhost;Initial Catalog=colorManagement;Integrated Security=True")
                Dim cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Color", colorName)
                cmd.Parameters.AddWithValue("@Price", price)
                cmd.Parameters.AddWithValue("@DisplayOrder", displayOrder)
                cmd.Parameters.AddWithValue("@ColorInStock", inStock)
                cmd.Parameters.AddWithValue("@ColorID", colorID)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error during update: " & ex.Message)
            Throw New Exception("שגיאה בעדכון הצבע: " & ex.Message)
        End Try
    End Sub

    ' מחיקת צבע
    <System.Web.Services.WebMethod()>
    Public Shared Sub DeleteColor(ByVal colorID As Integer)
        Try
            If colorID <= 0 Then
                Throw New Exception("ID לא תקני למחיקה.")
            End If

            Dim query As String = "DELETE FROM Colors WHERE ID = @ColorID"
            Using conn As New SqlConnection("Data Source=localhost;Initial Catalog=colorManagement;Integrated Security=True")
                Dim cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@ColorID", colorID)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Error during deletion: " & ex.Message)
            Throw New Exception("שגיאה במחיקת הצבע: " & ex.Message)
        End Try
    End Sub


    ' קריאה לכל הצבעים
    <System.Web.Services.WebMethod()>
    Public Shared Function GetColors() As List(Of Color)
        Dim colors As New List(Of Color)()
        Dim query As String = "SELECT * FROM Colors"
        Using conn As New SqlConnection("Data Source=localhost;Initial Catalog=colorManagement;Integrated Security=True")
            Dim cmd As New SqlCommand(query, conn)
            conn.Open()
            Dim reader As SqlDataReader = cmd.ExecuteReader()
            While reader.Read()
                Dim color As New Color()
                color.ID = reader("ID")
                color.ColorName = reader("Color")
                color.Price = reader("Price")
                color.DisplayOrder = reader("DisplayOrder")
                color.InStock = reader("ColorInStock")
                colors.Add(color)
            End While
        End Using
        Return colors
    End Function

End Class

Public Class Color
    Public Property ID As Integer
    Public Property ColorName As String
    Public Property Price As Decimal
    Public Property DisplayOrder As Integer
    Public Property InStock As Boolean
End Class
