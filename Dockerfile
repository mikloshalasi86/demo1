#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["../NewWebApp2/NewWebApp2.csproj", "../NewWebApp2/"]
RUN dotnet restore "../NewWebApp2/NewWebApp2.csproj"
COPY . .
WORKDIR "/src/../NewWebApp2"
RUN dotnet build "NewWebApp2.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NewWebApp2.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "NewWebApp2.dll"]