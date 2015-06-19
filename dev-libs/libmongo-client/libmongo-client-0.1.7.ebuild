# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmongo-client/libmongo-client-0.1.7.ebuild,v 1.7 2014/10/05 07:24:57 ago Exp $

EAPI=5

inherit eutils autotools

DESCRIPTION="The alternative C driver for MongoDB"
HOMEPAGE="https://github.com/algernon/libmongo-client"
SRC_URI="https://github.com/algernon/${PN}/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm hppa x86"
IUSE="doc"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"
RDEPEND="
	dev-libs/glib"

S=${WORKDIR}/${PN}-${P}

src_prepare() {
	eautoreconf
}

src_compile() {
	default
	use doc && emake DESTDIR="${D}" doxygen
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
	use doc && dohtml -r docs/html/*
}
