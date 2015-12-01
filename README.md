![Gilt Tech logo](https://raw.githubusercontent.com/gilt/Cleanroom/master/Assets/gilt-tech-logo.png)

# The Cleanroom Project

The Cleanroom Project began as an experiment to re-imagine Gilt’s iOS codebase in a legacy-free, Swift-based incarnation. 

Since then, we’ve expanded the Cleanroom Project to include multi-platform support. Much of our codebase now supports tvOS in addition to iOS, and our lower-level code is usable on Mac OS X and watchOS as well.

Cleanroom Project code serves as the foundation of Gilt on TV, our tvOS app [featured by Apple during the launch of the new Apple TV](http://www.apple.com/apple-events/september-2015/). And as time goes on, we'll be replacing more and more of our existing Objective-C codebase with Cleanroom implementations.

In the meantime, we’ll be tracking the latest releases of Swift & Xcode, and [open-sourcing major portions of our codebase](https://github.com/gilt/Cleanroom#open-source-by-default) along the way.

## Available Repositories

The Cleanroom Project is spread across several repositories, and we expect the list to continue growing. This page will serve as the definitive index for the available Cleanroom Project repos.

### Open Source

#### Cleanroom Core

##### Under Active Development

- [CleanroomAppSettings](http://github.com/emaloney/CleanroomAppSettings) — A set of interfaces and implementations to abstract away the app's NSUserDefaults singleton
- [CleanroomASL](http://github.com/emaloney/CleanroomASL) — A Swift-based API for reading from & writing to the Apple System Log facility
- [CleanroomBridging](http://github.com/emaloney/CleanroomBridging) — A set of tools to help bridge the gap between Objective-C and Swift
- [CleanroomConcurrency](http://github.com/emaloney/CleanroomConcurrency) — Utilities for simplifying asynchronous code execution & coordinating concurrent access to shared resources
- [CleanroomDateTime](http://github.com/emaloney/CleanroomDateTime) — Utilities for handling dates and times
- [CleanroomLogger](http://github.com/emaloney/CleanroomLogger) — A simple Swift-based logging API for iOS applications
- [CleanroomText](http://github.com/emaloney/CleanroomText) — Swift-based tools for working with strings and text

#### Avro Serialization

- [BlueSteel](https://github.com/gilt/BlueSteel) — A Swift API for working with Avro schemas and binary data

### Closed Source

- [CleanroomDataModel](https://github.com/gilt/CleanroomDataModel) — Gilt data model interfaces and implementations
- [CleanroomDeepLinking](https://github.com/gilt/CleanroomDeepLinking) — The core of the deep linking mechanism within the Cleanroom app
- [CleanroomGiltAPI](https://github.com/gilt/CleanroomGiltAPI) — The client-side Gilt API
- [CleanroomProductView](https://github.com/gilt/CleanroomProductView) — The Product View (PDP) and the deep link plumbing needed to navigate to it
- [CleanroomSaleView](https://github.com/gilt/CleanroomSaleView) — The Sale View (PLP) and the deep link plumbing needed to navigate to it
- [CleanroomScaffolding](https://github.com/gilt/CleanroomScaffolding) — Temporary scaffolding intended to support work on the Cleanroom app; this will go away at some point as we approach 1.0
- [CleanroomViewModel](https://github.com/gilt/CleanroomViewModel) — The MVVM *view models* for the Cleanroom app

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
