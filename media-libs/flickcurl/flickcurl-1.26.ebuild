# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="C library for the Flickr API"
HOMEPAGE="https://librdf.org/flickcurl/"
SRC_URI="https://download.dajobe.org/flickcurl/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 GPL-2 Apache-2.0 )"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE="raptor"

RDEPEND="
	>=net-misc/curl-7.10.0
	>=dev-libs/libxml2-2.6.8:2
	raptor? ( media-libs/raptor:2 )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gtk-doc-am
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-gtk-doc \
		$(use_with raptor)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
