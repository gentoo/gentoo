# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cmake-utils

DESCRIPTION="cmake modules that provides helper macros and targets for linux, especially fedora developers"
HOMEPAGE="https://fedorahosted.org/cmake-fedora/#Getcmake-fedora"
SRC_URI="https://fedorahosted.org/releases/c/m/cmake-fedora/${P}-Source.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${P}-Source
CMAKE_IN_SOURCE_BUILD=1
