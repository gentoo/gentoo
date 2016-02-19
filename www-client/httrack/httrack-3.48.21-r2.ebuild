# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="HTTrack Website Copier, Open Source Offline Browser"
HOMEPAGE="http://www.httrack.com/"
SRC_URI="http://mirror.httrack.com/historical/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="libressl static-libs"

RDEPEND=">=sys-libs/zlib-1.2.5.1-r1
	!libressl? ( dev-libs/openssl:= )
	libressl? ( dev-libs/libressl )
	"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README greetings.txt history.txt )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.48.13-minizip.patch
}

src_configure() {
	econf $(use_enable static-libs static) \
		--docdir=${EPREFIX}/usr/share/doc/${PF} \
		--htmldir=${EPREFIX}/usr/share/doc/${PF}/html
}

src_install() {
	default

	# Make webhttrack work despite FEATURES=nodoc cutting
	# all of /usr/share/doc/ away (bug #493376)
	if has nodoc ${FEATURES} ; then
		dodir /usr/share/${PF}/
		mv "${D}"/usr/share/{doc/,}${PF}/html || die

		rm "${D}"/usr/share/httrack/html || die
		dosym /usr/share/${PF}/html /usr/share/httrack/html
	fi

	find "${ED}" -type f -name '*.la' -delete || die
}
