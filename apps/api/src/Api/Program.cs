using System.Reflection;
using Microsoft.AspNetCore.Http.Json;

var builder = WebApplication.CreateBuilder(args);
builder.Services.Configure<JsonOptions>(o => o.SerializerOptions.PropertyNamingPolicy = System.Text.Json.JsonNamingPolicy.CamelCase);
var app = builder.Build();

// Version is stamped at publish time: dotnet publish -p:Version=<semver> -p:InformationalVersion=<semver>
var version = Assembly.GetEntryAssembly()?.GetCustomAttribute<AssemblyInformationalVersionAttribute>()?.InformationalVersion ?? "0.0.0-local";
var startedAt = DateTimeOffset.UtcNow;

app.MapGet("/", () => Results.Ok(new { service = "adlc-demo-api", version }));
app.MapGet("/health", () => Results.Ok(new HealthResponse("ok", version, startedAt)));
app.MapGet("/api/greeting", (string? name) => Results.Ok(new { message = $"Hello, {(string.IsNullOrWhiteSpace(name) ? "adlc" : name.Trim())}!", version }));

app.Run();

public sealed record HealthResponse(string Status, string Version, DateTimeOffset StartedAt);
public partial class Program { }
