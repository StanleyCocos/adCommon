# ad_common

8591与100项目共用库

## Getting Started

### 导入
```dart
dependencies:
  ad_common:                             # 公共库
    git:
      url: https://github.com/StanleyCocos/adCommon.git
      path: ad_common/ #路径
      ref: master      #正式分支
      //#ref: develop      #测试分支
```

### 初始化
- 本地存储初始化
```
SpManager.init(isDebug:false);
```
- 数据库初始化
```dart

```
- 网络请求初始化
```dart

```
- app信息初始化
```dart
AppInfoManager.instance.initInfo();
```
- 屏幕适配初始化
```dart
ScreenUtilInit(
        designSize: Size(750, 1334),
        allowFontScaling: true,
        builder: () => MaterialApp()
      );
```



