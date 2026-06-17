$port = 3000
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Output "Server listening on http://localhost:$port"
$filePath = Join-Path $PSScriptRoot "index.html"
while ($listener.IsListening) {
    $context = $listener.GetContext()
    $response = $context.Response
    try {
        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $response.ContentType = "text/html; charset=utf-8"
        $response.ContentLength64 = $bytes.Length
        $response.OutputStream.Write($bytes, 0, $bytes.Length)
    } catch {
        $response.StatusCode = 500
    } finally {
        $response.Close()
    }
}
