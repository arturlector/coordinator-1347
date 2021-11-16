//
//  ForecastViewModel.swift
//  swiftui-1347
//
//  Created by Artur Igberdin on 02.11.2021.
//

import Foundation
import SwiftUI
import RealmSwift

class ForecastViewModel: ObservableObject {
    
    // Отображаемый город
    let city: City
    
    // Сетевой сервис
    let weatherService: WeatherService
    // Сервис баз данных
    let realmService: AnyRealmService
    
    // Паблишер для подписки в SwiftUI.View
    let objectWillChange = ObjectWillChangePublisher()
    
    // Результаты запроса в БД
    private(set) lazy var weathers: Results<Weather>? = try? realmService.get(Weather.self, configuration: .deleteIfMigration).filter("id CONTAINS[cd] %@", city.name)
    
    // Копия результата запроса в БД
    var detachedWeathers: [Weather] { weathers?.map { $0.detached() } ?? [] }
    // Токен-обсервер БД
    
    private var notificationToken: NotificationToken?
    
     // Прогнозы погоды
    // @Published var weathers: [Weather] = []
     
     /// В инициализаторе вешаем обсервер на результаты из базы данных
    init(city: City, weatherService: WeatherService, realmService: AnyRealmService) {
        self.city = city
        self.weatherService = weatherService
        self.realmService = realmService
        
        notificationToken = weathers?.observe { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
     
//     /// Запрашиваем загрузку данных прогнозов погоды
//     public func fetchForecast() {
//         weatherService.forecast(for: city.name) { [weak self] result in
//             switch result {
//             case let .success(weathers):
//                 self?.weathers = weathers
//             case let .failure(error):
//                 print(error)
//             }
//         }
//     }
    
    public func fetchForecast() {
        print("Forecast requested")
        weatherService.forecast(for: city.name) { [weak self] result in
            switch result {
            case .success(let weathers):
                try? self?.realmService.save(items: weathers, configuration: .deleteIfMigration, update: .modified)
            case .failure(let error):
                print(error)
            }
        }
    }
}
