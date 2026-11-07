#!/usr/bin/env bash
set -euo pipefail
cargo build --release
cargo test --release
mkdir -p build
cp target/release/hello build/hello