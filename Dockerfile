FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

COPY src/WebApp/*.csproj ./WebApp/

RUN dotnet restore ./WebApp/WebApp.csproj

COPY src/WebApp ./WebApp

WORKDIR /src/WebApp

RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0

WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://0.0.0.0:8080

EXPOSE 8080

ENTRYPOINT ["dotnet", "WebApp.dll"]
