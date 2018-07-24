target 'EstimoteProximity' do
    use_frameworks!
    pod 'EstimoteProximitySDK'
    pod 'Alamofire'
    pod 'AlamofireImage'
    pod 'SwiftyJSON'
    pod 'ASHorizontalScrollView'
    pod 'ImageSlideshow'
    pod 'ImageSlideshow/Alamofire'
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    pod 'JSONWebToken'
    pod 'KeychainAccess'
    pod 'SkyFloatingLabelTextField'
    pod 'MBSegueCollection'
    pod 'PopupDialog'
    pod 'MarqueeLabel/Swift'
    pod 'IBAnimatable'
    pod 'SearchTextField'
    pod 'IQKeyboardManagerSwift'
    pod 'BadgeSwift'
    pod 'RealmSwift'
    pod 'Cosmos'
    pod 'ASHorizontalScrollView'
    pod 'ImageViewer'
    pod 'NotificationBannerSwift'
    pod 'MobilePlayer'
    pod 'PKHUD'
    pod 'SwiftyGif'
    pod 'LGButton'
    pod 'SwiftIconFont'
    pod 'StyleDecorator'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Firebase/Performance'
    pod 'RxSwift'
    pod 'RxCocoa'
end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['MobilePlayer'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
