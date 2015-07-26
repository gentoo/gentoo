# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nntp/slrn/slrn-1.0.2.ebuild,v 1.4 2015/07/23 19:57:45 pacho Exp $

EAPI=5
inherit autotools-utils

MY_P="${PN}_${PV/_/~}"

DESCRIPTION="A s-lang based newsreader"
HOMEPAGE="http://slrn.sourceforge.net/"
SRC_URI="http://jedsoft.org/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="canlock nls ssl uudeview"

RDEPEND="virtual/mta
	app-arch/sharutils
	>=sys-libs/slang-2.1.3
	canlock? ( net-libs/canlock )
	ssl? ( dev-libs/openssl )
	uudeview? ( dev-libs/uulib )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

AUTOTOOLS_IN_SOURCE_BUILD=1
PATCHES=( "${FILESDIR}"/${P}-make.patch )

src_configure() {
	local myeconfargs=(
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF}
		--with-slrnpull
		$(use_with canlock)
		$(use_with uudeview uu)
		$(use_enable nls)
		$(use_with ssl)
	)

	autotools-utils_src_configure
}
