# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-multilib

PATCHLEVEL="2"
DESCRIPTION="MPEG-1 and MPEG-4 video encoding library"
HOMEPAGE="http://fame.sourceforge.net/"
SRC_URI="mirror://sourceforge/fame/${P}.tar.gz
	http://digilander.libero.it/dgp85/gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE="cpu_flags_x86_mmx static-libs"

PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-mmx-configure.ac.patch )

DOCS=( AUTHORS BUGS CHANGES README TODO )

src_prepare() {
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/${PV}

	# Do not add -march=i586, bug #41770.
	sed -i -e 's:-march=i[345]86 ::g' configure.in || die

	rm -f acinclude.m4

	autotools-multilib_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable cpu_flags_x86_mmx mmx)
	)
	autotools-multilib_src_configure
}
