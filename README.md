# Xcode Source Editor Extension: "Outlet Fixer"
An Xcode Source Editor Extension to make IBOutlets weak, private and optional


Xcode Source Editor Extensions are located in Menu -> Editor. 
Select "Fix IBOutlets" to change all of your IBOutlets in your currently selected file to weak, private and optional.
It will also update your code to make sure to use your outlets as optionals. 

**Example**

```Swift
@IBOutlet weak var myView: UIView!

[...]

myView.backgroundColor = .blue
```

... will be modified to:

```Swift
@IBOutlet private weak var myView: UIView?

[...]

myView?.backgroundColor = .blue
```
