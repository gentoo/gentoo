# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="An easy to use library for the RELP protocol"
HOMEPAGE="http://www.librelp.com/"
SRC_URI="http://download.rsyslog.com/${PN}/${P}.tar.gz"

LICENSE="GPL-3+ doc? ( FDL-1.3 )"

# subslot = soname version
SLOT="0/0.1.0"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~sparc ~x86"
IUSE="debug doc +ssl static-libs"

RDEPEND="
	ssl? ( >=net-libs/gnutls-3.3.17.1:0= )
"

DEPEND="
	ssl? ( >=net-libs/gnutls-3.3.17.1:0= )
	virtual/pkgconfig
"

src_prepare() {
	sed -i \
		-e 's/ -g"/"/g' \
		configure.ac || die "sed failed"

	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable ssl tls)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	local DOCS=( ChangeLog )
	use doc && local HTML_DOCS=( doc/relp.html )
	default

	find "${ED}"usr/lib* -name '*.la' -delete || die
}
