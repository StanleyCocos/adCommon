### 项目概述
  adcommon 封装了以下功能
  1. MVC结构
  2. 网络请求
  3. 存储管理
  4. 常见扩展
  5. 路由
  6. 常见UI
  7. 权限管理
  8. 通知管理

### 网络请求
 ```
 HttpRequest.getInstance().get(
     "url",
     params: {"key": "value"},
     callBack: (data) {},
     errorCallBack: (error, stateCode) {},
     commonCallBack: () {},
  );
  ```
### 存储管理
#### 1. 偏好设置
```
// 存储
SpManager.setBool("key", true);
SpManager.setString("key", "true");

 // 获取
Object obj = SpManager.get("key");
String str = SpManager.getString("key", defaultValue: "");
```
#### 2. 数据库
1. 创建表
```
 class TestTable extends BaseTableModel {
          @override
          BaseTableModel copy() => TestTable();

          // 添加的表字段
          STText info = STText(defaultValue: "", canNull: false);
          STInt age = STInt(defaultValue: 20,);

          @override
          Map<String, BaseColumn> get map => {
            "info": info,
            "age": age,
            "id": id
          };
        }       
```
#### 操作
```
TestTable test1 = TestTable();
test1.age.content = 5;
test1.info.content = "info";
test1.save();
```
  
    
