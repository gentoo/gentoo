# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/opusfile/opusfile-0.4.ebuild,v 1.4 2014/04/13 15:17:59 jer Exp $

EAPI=5

DESCRIPTION="A high-level decoding and seeking API for .opus files"
HOMEPAGE="http://www.opus-codec.org/"
SRC_URI="http://downloads.xiph.org/releases/opus/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"
IUSE="doc fixed-point +float +http static-libs"

RDEPEND="media-libs/libogg
	media-libs/opus
	http? ( dev-libs/openssl )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

REQUIRED_USE="^^ ( fixed-point float )"

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable doc) \
		$(use_enable fixed-point)\
		$(use_enable float) \
		$(use_enable http) \
		$(use_enable static-libs static)
}
