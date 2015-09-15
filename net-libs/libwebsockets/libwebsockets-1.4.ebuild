# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

MY_TAG="chrome43-firefox-36"
DESCRIPTION="C/C++ websockets library"
HOMEPAGE="http://libwebsockets.org/"
SRC_URI="http://git.libwebsockets.org/cgi-bin/cgit/${PN}/snapshot/${P}-${MY_TAG}.tar.gz"
S="${S}-${MY_TAG}"

LICENSE="libwebsockets"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-util/cmake"
RDEPEND=""
