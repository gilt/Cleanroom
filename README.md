![HBC Digital logo](https://raw.githubusercontent.com/gilt/Cleanroom/master/Assets/hbc-digital-logo.png)     
![Gilt Tech logo](https://raw.githubusercontent.com/gilt/Cleanroom/master/Assets/gilt-tech-logo.png)

# The Cleanroom Project

The Cleanroom Project began as an experiment to re-imagine Gilt’s iOS codebase in a legacy-free, Swift-based incarnation. 

Since then, we’ve expanded the Cleanroom Project to include multi-platform support. Much of our codebase now supports tvOS in addition to iOS, and our lower-level code is usable on Mac OS X and watchOS as well.

Cleanroom Project code serves as the foundation of Gilt on TV, our tvOS app [featured by Apple during the launch of the new Apple TV](http://www.apple.com/apple-events/september-2015/). And as time goes on, we'll be replacing more and more of our existing Objective-C codebase with Cleanroom implementations.

In the meantime, we’ll be tracking the latest releases of Swift & Xcode, and [open-sourcing major portions of our codebase](https://github.com/gilt/Cleanroom#open-source-by-default) along the way.

## Active Repositories

The Cleanroom Project is spread across several repositories, and we expect the list to continue growing. This page will serve as the definitive index for the available open-source Cleanroom Project repos.

- [ApidocSwiftWriter](https://github.com/gilt/ApidocSwiftWriter) — Uses [SwiftPoet](https://github.com/gilt/SwiftPoet) to generate Swift source code files for implementing [apidoc](https://apidoc.me/) clients
- [BlueSteel](https://github.com/gilt/BlueSteel) — An Avro encoding/decoding library for Swift
- [CleanroomAppSettings](https://github.com/emaloney/CleanroomAppSettings) — A set of Swift interfaces and implementations to abstract away the app's NSUserDefaults singleton
- [CleanroomBridging](https://github.com/emaloney/CleanroomBridging) — A set of tools to help bridge the gap between Objective-C and Swift
- [CleanroomCLI](https://github.com/emaloney/CleanroomCLI) — Tools for handling command line arguments in Swift
- [CleanroomConcurrency](https://github.com/emaloney/CleanroomConcurrency) — Swift utilities for simplifying asynchronous code execution & coordinating concurrent access to shared resources
- [CleanroomDataTransactions](https://github.com/emaloney/CleanroomDataTransactions) — A protocol-independent and format-agnostic Swift library for performing one-way and two-way data transactions; we use this as the basis of communicating with our back-end services
- [CleanroomDateTime](https://github.com/emaloney/CleanroomDateTime) — Utilities for handling dates and times in Swift
- [CleanroomLogger](https://github.com/emaloney/CleanroomLogger) — A simple Swift-based console logging API
- [CleanroomRepoTools](https://github.com/emaloney/CleanroomRepoTools) — Tools for automating the management of Cleanroom-style git repos; handles generating boilerplate files and deploying both generated and static files across multiple repos
- [CleanroomText](https://github.com/emaloney/CleanroomText) — Swift tools for working with strings and text
- [SwiftPoet](https://github.com/gilt/SwiftPoet) — A Swift framework for generating Swift code in Swift

## Deprecated Repositories

- [CleanroomASL](http://github.com/gilt/CleanroomASL) — A Swift-based API for reading from & writing to the Apple System Log facility. This project is deprecated as a result of Apple’s deprecation of the ASL itself.

## Open Source by Default

By default, we will strive to release all Cleanroom Project code through an appropriate open-source license.

Open-source Cleanroom Project repos **must**:

- Have an *explicit maintainer* responsible for long-term servicing. The minimum responsibility of the maintainer is to ensure continued compatibility with the latest production-supported development tools.

Open-source Cleanroom Project repos **should**:

- In keeping with the recommendation of Gilt Tech's Open-Source Working Group, the origin repo should by default be released under the maintainer's personal GitHub account. If the maintainer chooses not to do that, the repo **should** be released under [the Gilt account](https://github.com/gilt/) on GitHub, and the maintainer **must** be explicitly named in the repo's root README.
- Unless there is a specific reason to deviate, we will use the language of [the MIT license](https://github.com/gilt/Cleanroom/blob/master/LICENSE) contained in this repository.

### When we don't open-source

If the repo in question falls into any of the following categories, we will not be releasing it open-source:

- The code is still in flux and multiple sets of breaking changes are likely in the short-term
- Sufficient documentation does not yet exist to make productive use of the code
- The code is too specific to Gilt and not likely to be useful to the general public
- The repo contains intellectual property or other information that we can't disclose publicly

Whenever we decide against releasing something publicly, we should periodically re-evaluate the decision to check whether the conditions that led to the original decision still apply.

## Contributing to the Cleanroom Project

We welcome contributions to all the various Cleanroom Project repositories.

Contributing can take many forms, but to make administering the process easier, we handle all contributions in one of two ways:

### Making Suggestions &amp; Pointing Out Problems

Such contributions include:

- Reporting bugs
- Sending feature requests
- Pointing out typos

For these types of contributions, **please create a [GitHub Issue](https://guides.github.com/features/issues/) in the appropriate repo** containing the message that you'd like to convey.

### Improving the Codebase

This would include:

- Fixing bugs
- Tweaking project file settings
- Writing unit tests
- Submitting performance and other code improvements
- Adding new features

To contribute in this way, **please [submit a pull request](https://help.github.com/articles/using-pull-requests/)** by:

1. [Forking the repo](https://help.github.com/articles/fork-a-repo/) to which you'd like to submit a contribution
2. Committing changes to your fork
3. Pushing your changes to GitHub
4. Submitting a pull request from your changes

If your pull request is related to something already tracked in a GitHub Issue, please be sure to note the issue number (and include a link to the issue page) in your pull request.

### Licensing

By submitting a pull request, you inherently grant Gilt a license to redistribute your work under the same license that governs the repository to which you're contributing.
