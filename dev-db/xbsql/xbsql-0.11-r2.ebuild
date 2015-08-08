# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils

DESCRIPTION="An SQL Wrapper for the XBase library"
HOMEPAGE="http://www.rekallrevealed.org/"
SRC_URI="http://www.rekallrevealed.org/packages/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
IUSE="doc static-libs"

RDEPEND="
	>=dev-db/xbase-3.1.2
	sys-libs/readline"
DEPEND="${RDEPEND}
	sys-devel/automake
	sys-devel/libtool"

PATCHES=(
	"${FILESDIR}"/${P}-ncurses64.patch
	"${FILESDIR}"/${P}-xbase64.patch
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-bfr-overflow.patch
)

DOCS=( AUTHORS Announce ChangeLog INSTALL README TODO )

AUTOTOOLS_IN_SOURCE_BUILD=1

src_install() {
	autotools-utils_src_install
	use doc && dohtml doc/*
}
