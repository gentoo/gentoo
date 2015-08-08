# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic libtool

MY_P=${PN}-${PV/_/-}

DESCRIPTION="Library for accessing and manipulating reiserfs partitions"
HOMEPAGE="http://reiserfs.linux.kiev.ua/"
SRC_URI="http://reiserfs.linux.kiev.ua/snapshots/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ~ppc64 ~sparc x86"
IUSE="debug examples nls static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-apps/util-linux
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-autotools.patch

	elibtoolize
}

src_configure() {
	filter-lfs-flags

	econf \
		$(use_enable static-libs static) \
		--disable-Werror \
		$(use_enable nls) \
		$(use_enable debug)
}

src_install() {
	default

	if use examples; then
		docinto examples
		dodoc demos/*.c
	fi

	rm -r "${ED}"/usr/{sbin,share/man} || die
	prune_libtool_files
}

pkg_postinst() {
	ewarn "progsreiserfs has been proven dangerous in the past, generating bad"
	ewarn "partitions and destroying data on resize/cpfs operations."
	ewarn "Because of this, we do NOT provide their binaries, but only their"
	ewarn "libraries instead, as these are needed for other applications."
}
