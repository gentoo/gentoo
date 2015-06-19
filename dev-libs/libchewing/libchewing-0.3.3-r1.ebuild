# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libchewing/libchewing-0.3.3-r1.ebuild,v 1.2 2015/04/19 11:41:03 blueness Exp $

EAPI=5

inherit autotools eutils multilib toolchain-funcs

DESCRIPTION="Library for Chinese Phonetic input method"
HOMEPAGE="http://chewing.csie.net/"
SRC_URI="http://chewing.csie.net/download/libchewing/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="static-libs test"

DEPEND="
	virtual/pkgconfig
	test? (
		sys-libs/ncurses[unicode]
		>=dev-libs/check-0.9.4
	)
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-cflags.patch \
		"${FILESDIR}"/${PV}-strncat-fix.patch \
		"${FILESDIR}"/${PV}-tinfo.patch

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_test() {
	# test subdirectory is not enabled by default; this means that we
	# have to make it explicit.
	emake -C test check
}

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_install() {
	default

	prune_libtool_files
}
