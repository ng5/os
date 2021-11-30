#!/usr/bin/env bash
IS_INTEL=$(lscpu | grep -c GenuineIntel)
if [[ "$IS_INTEL" -ge 1 ]]; then
    IS_INTEL=true
else
    IS_INTEL=false
fi
IS_AMD=$(lscpu | grep -c AuthenticAMD)
if [[ "$IS_AMD" -ge 1 ]]; then
    IS_AMD=true
else
    IS_AMD=false
fi
echo "IS_INTEL - $IS_INTEL"
echo "IS_AMD - $IS_AMD"
if $IS_INTEL; then
    echo "intel cpu"
fi
if $IS_AMD; then
    echo "amd cpu"
fi