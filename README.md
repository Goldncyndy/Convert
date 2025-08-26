Convert

# Currency Converter App

The Currency Converter App is a simple yet powerful iOS application that allows users to convert between multiple currencies in real-time. It fetches live exchange rates from an external API and provides an intuitive, user-friendly interface for quick conversions.

It is an iOS application built as part of an assessment project.

It allows users to convert between multiple currencies in real-time, fetching live exchange rates from an API and presenting them through a simple, intuitive interface.

## Features

* 🌍 Real-Time Exchange Rates – fetches up-to-date currency rates from an API.
* 🔄 Currency Conversion – instantly converts one currency to another.
* 📊 Market View with Line Charts – visualizes historical trends of selected currency pairs using DGCharts.
* 📱 Clean & Responsive UI – built with UIKit for smooth performance.
* ⚡ Offline Handling – stores the last fetched rates for use without internet.


🛠️ Tech Stack

 *   UIKit – iOS native UI framework.

 *   Alamofire – for handling API requests.

 *   SwiftyJSON – for easy JSON parsing.

 *   DGCharts – for rendering line charts in the Market View.

 *   Swift Package Manager (SPM) – dependency management.
    

## ⚙️ Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/CurrencyConverterApp.git
   cd CurrencyConverterApp
   ```

2. Open the project in Xcode:

   ```bash
   open CurrencyConverterApp.xcodeproj
   ```

3. Dependencies are handled via Swift Package Manager, so Xcode will automatically fetch them.

4. Build & Run on your simulator or device.

## 🔑 API Setup

This app uses the ExchangeRate API
 (no authentication required).

If switching to another API, update the configuration inside RateService.swift.


## 📊 Market View (Line Chart)

The Market View uses DGCharts (LineChartView) to display historical exchange rate trends.
Users can select a currency pair, and the chart updates to reflect daily changes over a given period.


