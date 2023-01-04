# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# inherit --- no eclasses needed

# Description of package.
DESCRIPTION="Small library for RaspberryPi control of GPIO"

# lg lib homepage
HOMEPAGE="http://abyz.me.uk/lg/"

# Using of PN variable avoided, Following note in
# https://wiki.gentoo.org/wiki/Basic_guide_to_write_Gentoo_Ebuilds
SRC_URI="https://github.com/joan2937/lg/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/joan2937/lg/archive/refs/tags/v${PV}.zip -> ${P}.zip"

# License of the package
LICENSE="Unlicense"

# keep single version of the library installed, so default
SLOT="0"

# for Raspberry pi
KEYWORDS="arm arm64"

# ebuild doesn't use any USE flags

# Following-> Implicit System Dependency(*): Not necessary, nor advisable,
# to specify dependencies [..] like gcc, libc and so on. Note this needs
# consideration for packages like flex, zlib and libtool, which aren't
# in the @system set [...] (or) might get removed in future.
# (*)https://devmanual.gentoo.org/general-concepts/dependencies/index.html#implicit-system-dependency

# Run-time dependencies. none, simple cpp lib from source
RDEPEND=""

# Build-time dependencies that need to be binary compatible with the system
# being built (CHOST). none, simple cpp lib from source
DEPEND=""

# Build-time dependencies
BDEPEND="app-arch/unzip"

# #################################################################
# Provided Makefile allows using Default phase funtion behaviour:
#   default_pkg_nofetch
#   default_src_unpack
#   default_src_prepare
#   default_src_configure
#   default_src_compile
#   default_src_test
#   default_src_install
# #################################################################
