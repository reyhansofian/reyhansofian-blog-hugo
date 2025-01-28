#!/bin/bash

# Check template errors (updated flags)
hugo server --templateMetrics --templateMetricsHints --renderStaticToDisk

# Dry-run build with modern logging
HUGO_LOG_LEVEL=info hugo --buildDrafts --buildFuture
