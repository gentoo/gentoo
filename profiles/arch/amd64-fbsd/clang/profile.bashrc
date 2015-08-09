#!/bin/bash
# Copyright 1999-2015 Gentoo Foundation; Distributed under the GPL v2
# $Id$

# Check if clang/clang++ exist before setting them so that we can more easily
# switch to this profile and build stages.
type -P clang > /dev/null && export CC=clang
type -P clang++ > /dev/null && [ -f /usr/lib/libc++.so ] && export CXX="clang++ -stdlib=libc++"
