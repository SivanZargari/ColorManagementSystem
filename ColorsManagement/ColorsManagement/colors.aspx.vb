Imports System.Data.SqlClient
Imports System.Web.Services

Partial Class Colors
    Inherits System.Web.UI.Page

    ' Connection string to the database
    Shared connString As String = "Data Source=SIVANZARGARI120\SQLEXPRESS;Initial Catalog=colorManagement;Integrated Security=True"

    ' Update color method
    <WebMethod()>
    Public Shared Function UpdateColor(ByVal colorID As Integer, ByVal colorName As String, ByVal price As Decimal, ByVal displayOrder As Integer, ByVal inStock As Boolean) As String
        Try
            Using conn As New SqlConnection(connString)
                Dim query As String = "
                UPDATE ColorsManagement
                SET ColorName = @ColorName, 
                    Price = @Price, 
                    DisplayOrder = @DisplayOrder, 
                    InStock = @InStock 
                WHERE ID = @ColorID"
                Dim cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@ColorID", colorID)
                cmd.Parameters.AddWithValue("@ColorName", colorName)
                cmd.Parameters.AddWithValue("@Price", price)
                cmd.Parameters.AddWithValue("@DisplayOrder", displayOrder)
                cmd.Parameters.AddWithValue("@InStock", inStock)

                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
            Return "Color updated successfully."
        Catch ex As Exception
            Return "Error updating color: " & ex.Message
        End Try
    End Function

    ' Delete color method
    <WebMethod()>
    Public Shared Function DeleteColor(ByVal colorID As Integer) As String
        Try
            Using conn As New SqlConnection(connString)
                Dim query As String = "DELETE FROM ColorsManagement WHERE ID = @ColorID"
                Dim cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@ColorID", colorID)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
            Return "Color deleted successfully."
        Catch ex As Exception
            Return "Error deleting color: " & ex.Message
        End Try
    End Function

    ' Get all colors method
    <WebMethod()>
    Public Shared Function GetColors() As List(Of Color)
        Debug.WriteLine("ggggggg")
        Console.WriteLine("ggggggg")

        Dim colors As New List(Of Color)()
        Try


            Using conn As New SqlConnection(connString)
                Dim query As String = "SELECT ID, Color, Price, DisplayOrder, ColorInStock FROM ColorsManagement"
                Dim cmd As New SqlCommand(query, conn)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        colors.Add(New Color() With {
                            .ID = Convert.ToInt32(reader("ID")),
                            .ColorName = reader("Color").ToString(),
                            .Price = Convert.ToDecimal(reader("Price")),
                            .DisplayOrder = Convert.ToInt32(reader("DisplayOrder")),
                            .InStock = Convert.ToBoolean(reader("ColorInStock"))
                        })
                    End While
                End Using
            End Using
        Catch ex As Exception
            ' Handle exception
        End Try
        Return colors
    End Function
End Class

' Color class definition
Public Class Color
    Public Property ID As Integer
    Public Property ColorName As String
    Public Property Price As Decimal
    Public Property DisplayOrder As Integer
    Public Property InStock As Boolean
End Class
