# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/zpaq/zpaq-6.49.ebuild,v 1.2 2014/10/30 15:47:22 mgorny Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils eutils flag-o-matic

MY_P=${PN}${PV/./}
DESCRIPTION="Journaling incremental deduplicating archiving compressor"
HOMEPAGE="http://mattmahoney.net/dc/zpaq.html"
SRC_URI="http://mattmahoney.net/dc/${MY_P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="~app-arch/libzpaq-${PV}
	dev-libs/libdivsufsort"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_prepare() {
	EPATCH_OPTS+=-p1 epatch "${FILESDIR}"/${PN}-4-autotools.patch
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
	)

	append-cppflags -Dunix
	autotools-utils_src_configure
}

pkg_postinst() {
	elog "You may also want to install app-arch/zpaq-extras package which provides"
	elog "few additional configs and preprocessors for use with zpaq."
}
