# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/liblrdf/liblrdf-0.5.0.ebuild,v 1.7 2012/05/05 08:02:36 jdhore Exp $

EAPI=4
inherit autotools

DESCRIPTION="A library for the manipulation of RDF file in LADSPA plugins"
HOMEPAGE="http://github.com/swh/LRDF"
SRC_URI="http://github.com/swh/LRDF/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="static-libs"

RDEPEND=">=dev-libs/openssl-1
	media-libs/raptor:2
	>=media-libs/ladspa-sdk-1.12"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README )

src_unpack() {
	unpack ${A}
	mv *-LRDF-* "${S}"
}

src_prepare() {
	sed -i -e 's:usr/local:usr:' examples/{instances,remove}_test.c || die #392221
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_test() {
	has_version media-plugins/swh-plugins && default #392221
}

src_install() {
	default
	rm -f "${ED}"usr/lib*/liblrdf.la
}
