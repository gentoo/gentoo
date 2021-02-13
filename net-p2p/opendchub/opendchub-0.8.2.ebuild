# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="hub software for Direct Connect"
HOMEPAGE="http://opendchub.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE="perl"

RDEPEND="perl? ( dev-lang/perl )"
DEPEND="${RDEPEND}"

DOCS="NEWS TODO README AUTHORS Documentation/*"
PATCHES=( "${FILESDIR}"/${P}-telnet.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-flags -fcommon
	use perl || myconf="--disable-perl --enable-switch_user"
	econf ${myconf}
}

src_install() {
	default

	if use perl ; then
		dobin "${FILESDIR}"/opendchub_setup.sh
		insinto /usr/share/opendchub/scripts
		doins Samplescripts/*
	fi
}

pkg_postinst() {
	if use perl ; then
		echo
		einfo "To set up perl scripts for opendchub to use, please run"
		einfo "opendchub_setup.sh as the user you will be using opendchub as."
		echo
	fi
}
