![Gilt Tech logo](https://raw.githubusercontent.com/gilt/Cleanroom/master/Assets/gilt-tech-logo.png)

# The Cleanroom Project

The Cleanroom Project is an experiment in re-imagining Gilt's iOS codebase in a legacy-free incarnation that embraces the latest Apple technology.

We'll be tracking the most up-to-date releases of Swift, iOS and Xcode, and we'll be open-sourcing major portions of our code as we go.

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

## Available Repositories

The Cleanroom Project is spread across several repositories, and we expect the list to continue growing. This page will serve as the definitive index for the available Cleanroom Project repos.

### Open Source

#### Cleanroom Core

- [CleanroomBase](http://github.com/emaloney/CleanroomBase) — Low-level utilities useful for developing Swift-based iOS applications. *Note: CleanroomBase is deprecated, and will eventually be replaced by smaller, subject-specific projects.*
- [CleanroomASL](http://github.com/emaloney/CleanroomASL) — A Swift-based API for reading from & writing to the Apple System Log facility
- [CleanroomConcurrency](http://github.com/emaloney/CleanroomConcurrency) — Utilities for simplifying asynchronous code execution & coordinating concurrent access to shared resources
- [CleanroomDateTime](http://github.com/emaloney/CleanroomDateTime) — Utilities for handling dates and times
- [CleanroomLogger](http://github.com/emaloney/CleanroomLogger) — A simple Swift-based logging API for iOS applications

#### Avro Serialization

- [BlueSteel](https://github.com/gilt/BlueSteel) — A Swift API for working with Avro schemas and binary data

### Closed Source

- [CleanroomDeepLinking](https://github.com/gilt/CleanroomDeepLinking) — The core of the deep linking mechanism within the Cleanroom app
- [CleanroomScaffolding](https://github.com/gilt/CleanroomScaffolding) — Temporary scaffolding intended to support work on the Cleanroom app; this will go away at some point as we approach 1.0
- [CleanroomDataModel](https://github.com/gilt/CleanroomDataModel) — Gilt data model interfaces and implementations
- [CleanroomViewModel](https://github.com/gilt/CleanroomViewModel) — The MVVM *view models* for the Cleanroom app
- [CleanroomSaleView](https://github.com/gilt/CleanroomSaleView) — The Sale View (PLP) and the deep link plumbing needed to navigate to it
- [CleanroomProductView](https://github.com/gilt/CleanroomProductView) — The Product View (PDP) and the deep link plumbing needed to navigate to it

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
