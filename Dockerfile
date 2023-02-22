#FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
#FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim AS base
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
ARG ENV_VAR
ENV ASPNETCORE_ENVIRONMENT=$ENV_VAR
WORKDIR /app
EXPOSE 80
EXPOSE 443


#FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY eShopOnWeb.sln ./
COPY . .
RUN dotnet restore "Equinox.sln"

WORKDIR "/src/."
RUN dotnet build "Equinox.sln" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Equinox.sln" -c Release -o /app/publish
RUN pwd
RUN ls

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Equinox.UI.Web.dll"]