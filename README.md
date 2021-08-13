# flutter_infinite_scroll
Intended for personal use in my projects but feel free to use also.

Opinionated  package to lazily load and display small chunks of items as the user scrolls down the screen. Uses Dio and flutter bloc library

## Getting Started
Install package with: flutter pub add flutter_infinite_scroll

## Default options

InfiniteScrollPage(
      loadMoreEnabled: false,
       perPage: 10,
       debounceMaxPeriod: 5000, // milliseconds,
   },
);

## Usage
- Data endpoint must return  a single array like following
    [
        {
            id: 1,
            title: 'data title',
            description: 'data description',
            avatarPath: 'avatar path' (optional)
        },
        ... ...
    ]

- Endpoint is Post fixed with ?page=0 to help server side determine the next page
  e.g: https://example.com?page=1
