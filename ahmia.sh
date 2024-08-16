#!/bin/bash

# Check for exactly one argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <search-term>"
  exit 1
fi

# Assign the first argument to a variable
QUERY="$1"

# Encode the search term for URL usage
ENCODED_QUERY=$(echo "$QUERY" | sed 's/ /%20/g')

# Fetch the search results page
curl -s "https://ahmia.fi/search/?q=${ENCODED_QUERY}" |

# Extract URLs from href attributes within <a> tags
grep -oP 'href="/search/redirect\?search_term=[^&]*&redirect_url=\K[^"]*' |

# Remove duplicates and sort the URLs
sort -u > "${QUERY}.txt"

echo "Redirect URLs have been saved to ${QUERY}.txt"
