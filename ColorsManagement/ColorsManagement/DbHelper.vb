'Imports System.Data.SqlClient
'Imports System.Configuration

'Public Class DbHelper
'    ' מקבל את מיתר החיבור מ-Web.config
'    Public Shared Function GetConnection() As SqlConnection
'        Dim connectionString As String = ConfigurationManager.ConnectionStrings("MyDbConnection").ConnectionString
'        Return New SqlConnection(connectionString)
'    End Function

'    ' פעולת קריאה מתוך מסד הנתונים
'    Public Shared Sub GetColors()
'        Using connection As SqlConnection = GetConnection()
'            Try
'                connection.Open()
'                Dim command As New SqlCommand("SELECT * FROM Colors", connection)
'                Dim reader As SqlDataReader = command.ExecuteReader()
'                While reader.Read()
'                    Console.WriteLine(reader("ColorName").ToString())
'                End While
'                reader.Close()
'            Catch ex As Exception
'                Console.WriteLine("Error: " & ex.Message)
'            End Try
'        End Using
'    End Sub

'    ' פעולת הוספה למסד הנתונים
'    Public Shared Sub AddColor(colorName As String, price As Decimal)
'        Using connection As SqlConnection = GetConnection()
'            Try
'                connection.Open()
'                Dim command As New SqlCommand("INSERT INTO Colors (ColorName, Price) VALUES (@ColorName, @Price)", connection)
'                command.Parameters.AddWithValue("@ColorName", colorName)
'                command.Parameters.AddWithValue("@Price", price)
'                command.ExecuteNonQuery()
'            Catch ex As Exception
'                Console.WriteLine("Error: " & ex.Message)
'            End Try
'        End Using
'    End Sub
'End Class
