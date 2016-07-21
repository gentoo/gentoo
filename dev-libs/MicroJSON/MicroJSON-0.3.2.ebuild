# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit cmake-utils

DESCRIPTION="Small and simple to use JSON generation and parsing library"
HOMEPAGE="http://grigory.info/${PN}.About.html"
SRC_URI="http://grigory.info/distfiles/${P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~mips ~x86 ~amd64-linux ~x86-linux"
SLOT="0"

RDEPEND=">=dev-libs/UTF8Strings-1.12.0"

DEPEND="${RDEPEND}"
