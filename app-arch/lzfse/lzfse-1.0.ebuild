# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
CMAKE_INSTALL_PREFIX=""

inherit cmake

DESCRIPTION="LZFSE compression utilities"
HOMEPAGE="https://github.com/lzfse/lzfse"
SRC_URI="https://github.com/lzfse/lzfse/archive/refs/tags/lzfse-${PV}.tar.gz"
S="${WORKDIR}/${PN}-lzfse-${PV}"
LICENSE="BSD"
SLOT="0"
KEYWORDS="arm64"
