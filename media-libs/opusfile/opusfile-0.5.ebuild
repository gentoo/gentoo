# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/opusfile/opusfile-0.5.ebuild,v 1.3 2014/07/19 17:27:13 klausman Exp $

EAPI=5

DESCRIPTION="A high-level decoding and seeking API for .opus files"
HOMEPAGE="http://www.opus-codec.org/"
SRC_URI="http://downloads.xiph.org/releases/opus/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~x86"
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
