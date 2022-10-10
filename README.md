# VaccineCenter

### Info.
- iOS Deployment Target: 13.0
- Xcode Version 13.4.1 
- Interface: UIKit
- Library: SnapKit 5.0.0, RxSwift 6.0.0
- Design Architecture: MVVM
- 22.10.7 ~ 22.10.10

#### 인증키는 보안상 Github에 올리면 안될거 같아, xcconfig로 작성하여 Git Ignore 시켰습니다.
클론 후 실행할 시, VaccineCenter/Sources/Util/ConfidentialKey.swift 19번 라인 다음 코드 추가부탁드립니다.

```swift
return "Infuser \(인증키)" 
```

### Filepath

    ├── VaccineCenter
    │   ├── Resource
    │   │   └── Assets.xcassets
    │   │       ├── AccentColor.colorset
    │   │       │   └── Contents.json
    │   │       ├── AppIcon.appiconset
    │   │       │   └── Contents.json
    │   │       ├── Contents.json
    │   │       ├── building.imageset
    │   │       │   ├── Contents.json
    │   │       │   └── building.png
    │   │       ├── chat.imageset
    │   │       │   ├── Contents.json
    │   │       │   └── chat.png
    │   │       ├── hospital.imageset
    │   │       │   ├── Contents.json
    │   │       │   └── hospital.png
    │   │       ├── placeholder.imageset
    │   │       │   ├── Contents.json
    │   │       │   └── placeholder.png
    │   │       ├── telephone.imageset
    │   │       │   ├── Contents.json
    │   │       │   └── telephone.png
    │   │       └── top-alignment.imageset
    │   │           ├── Contents.json
    │   │           └── top-alignment.png
    │   ├── Sources
    │   │   ├── Entry
    │   │   │   ├── AppDelegate.swift
    │   │   │   └── SceneDelegate.swift
    │   │   ├── Model
    │   │   │   └── VaccineCenterModel.swift
    │   │   ├── Scene
    │   │   │   ├── CenterLoaction
    │   │   │   │   ├── CenterLocationViewController.swift
    │   │   │   │   ├── CenterLocationViewModel.swift
    │   │   │   │   └── VaccineCenterAnnotation.swift
    │   │   │   ├── Detail
    │   │   │   │   ├── DetailVaccineCenterViewController.swift
    │   │   │   │   ├── DetailVaccineCenterViewModel.swift
    │   │   │   │   └── VaccineCenterContentView.swift
    │   │   │   └── List
    │   │   │       ├── ListVaccineCenterViewController.swift
    │   │   │       ├── ListVaccineCenterViewModel.swift
    │   │   │       └── VaccineCenterCell.swift
    │   │   ├── Service
    │   │   │   └── Network
    │   │   │       ├── APIEndpoint.swift
    │   │   │       ├── Endpoint.swift
    │   │   │       ├── NetworkAPIConfiguration.swift
    │   │   │       ├── NetworkDataTransferService.swift
    │   │   │       ├── NetworkService.swift
    │   │   │       └── RequestProtocol.swift
    │   │   └── Util
    │   │       ├── ConfidentialKey.swift
    │   │       ├── UIView+Rounded.swift
    │   │       ├── UIView+SafeArea.swift
    │   │       └── UIView+Shadow.swift
    │   └── Supportings
    │       ├── Base.lproj
    │       │   └── LaunchScreen.storyboard
    │       ├── ConfidentialKey.xcconfig
    │       └── Info.plist
    ├── VaccineCenter.xcodeproj
    │   ├── project.pbxproj
    │   ├── project.xcworkspace
    │   │   ├── contents.xcworkspacedata
    │   │   ├── xcshareddata
    │   │   │   ├── IDEWorkspaceChecks.plist
    │   │   │   └── swiftpm
    │   │   │       └── Package.resolved
    │   │   └── xcuserdata
    │   │       └── doyoung.xcuserdatad
    │   │           └── UserInterfaceState.xcuserstate
    │   └── xcuserdata
    │       └── doyoung.xcuserdatad
    │           ├── xcdebugger
    │           │   └── Breakpoints_v2.xcbkptlist
    │           └── xcschemes
    │               └── xcschememanagement.plist
    └── VaccineCenterTests
        ├── NetworkServiceTests.swift
        └── ViewModels
            └── ListVaccineCenterViewModelTests.swift
