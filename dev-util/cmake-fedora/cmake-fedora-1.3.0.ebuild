# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cmake-fedora/cmake-fedora-1.3.0.ebuild,v 1.3 2015/01/26 10:12:01 ago Exp $

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
