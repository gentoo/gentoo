# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit versionator flag-o-matic eutils

MY_PV=$(replace_version_separator 2 '-' )
UPSTREAM_VERSION=$(get_version_component_range 1-2)
URL="http://www-asim.lip6.fr/pub/alliance/distribution/${UPSTREAM_VERSION}"

DESCRIPTION="Digital IC design tools (simulation, synthesis, place/route, etc...)"
HOMEPAGE="https://soc-extras.lip6.fr/en/alliance-abstract-en/"
SRC_URI="${URL}/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2 LGPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=x11-libs/motif-2.3:0
	x11-libs/libXpm
	x11-libs/libXt"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${UPSTREAM_VERSION}"

src_prepare() {
	#fix buffer overrun (bug 340789)
	epatch \
		"${FILESDIR}"/${PN}-${UPSTREAM_VERSION}.20070718-overun.patch \
		"${FILESDIR}"/${P}-impl-dec.patch
}

src_configure() {
	# Fix bug #134285
	replace-flags -O3 -O2

	# Alliance requires everything to be in the same directory
	econf \
		--prefix=/usr/lib/${PN} \
		--mandir=/usr/lib/${PN}/man \
		--with-x \
		--with-motif \
		--with-xpm \
		--with-alc-shared
}

src_compile() {
	# See bug #134145
	emake -j1
}

src_install() {
	make install DESTDIR="${D}"
	insinto /etc
	newins distrib/etc/alc_env.sh alliance.env
}

pkg_postinst() {
	elog "Users should source /etc/alliance.env before working with Alliance tools."
}
