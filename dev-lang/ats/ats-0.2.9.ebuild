# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="ATS Programming Language"
HOMEPAGE="http://www.ats-lang.org"
SRC_URI="http://downloads.sourceforge.net/project/ats-lang/ats-lang/anairiats-${PV}/${PN}-lang-anairiats-${PV}.tgz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/glib
	x11-libs/gtk+:2
	sys-libs/ncurses
	dev-libs/gmp
	dev-libs/libpcre
	virtual/opengl
	media-libs/libsdl
	dev-libs/boehm-gc
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	"

S="${WORKDIR}"/ats-lang-anairiats-${PV}

src_compile() {
	emake -j1
}
