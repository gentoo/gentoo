# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="Open source Text Summarizer, as used in newer releases of abiword and kword"
HOMEPAGE="http://libots.sourceforge.net/"
SRC_URI="mirror://sourceforge/libots/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~mips ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	>=dev-libs/libxml2-2.4.23
	>=dev-libs/popt-1.5
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS="AUTHORS BUGS ChangeLog HACKING NEWS README TODO"

src_prepare() {
	# ugly ugly hack, kick upstream to fix its packaging
	touch "${S}"/gtk-doc.make

	epatch "${FILESDIR}"/${P}-math.patch
	epatch "${FILESDIR}"/${P}-automake-1.13.patch
	epatch "${FILESDIR}"/${P}-fix-installation.patch
	epatch "${FILESDIR}"/${P}-fix-underlinking.patch
	eautoreconf
}

src_configure() {
	# bug 97448
	econf \
		--disable-gtk-doc \
		--disable-static
}

src_compile() {
	# parallel make fails, bug 112932
	emake -j1
}

src_install() {
	default
	prune_libtool_files
	rm -rf "${D}"/usr/share/doc/libots
}
