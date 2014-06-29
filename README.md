# List

This is a Swift microframework which implements an immutable singly-linked List.

## Use

```swift
// Concatenation
List(elements: [1, 2, 3]) ++ List(elements: [4, 5, 6])
// => List(elements: [1, 2, 3, 4, 5, 6])
```

See [`List.swift`][List.swift] for more details.

## Integration

1. Add this repo as a submodule in e.g. `External/List`:
  
        git submodule add https://github.com/robrix/List.git External/List
2. Drag `List.xcodeproj` into your `.xcworkspace`/`.xcodeproj`.
3. Add `List.framework` to your target’s `Link Binary With Libraries` build phase.
4. You may also want to add a `Copy Files` phase which copies `List.framework` (and any other framework dependencies you need) into your bundle’s `Frameworks` directory. If your target is a framework, you may instead want the client app to include `List.framework`.

[List.swift]: https://github.com/robrix/List/blob/master/List/List.swift
