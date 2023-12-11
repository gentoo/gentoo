# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_USE_PROJECTS=( clang clang-tools-extra lld )
PYTHON_COMPAT=( python3_{10..12} )
inherit llvm-toolchain
