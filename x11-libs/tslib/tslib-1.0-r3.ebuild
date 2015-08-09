# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs autotools multilib-minimal

PATCH_VER="5"
DESCRIPTION="Touchscreen Access Library"
HOMEPAGE="https://github.com/kergoth/tslib"
SRC_URI="http://dev.gentoo.org/~mgorny/dist/${P}.tar.bz2
	mirror://gentoo/${P}-patches-${PATCH_VER}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""
#extras arctic2 collie corgi h3600 linear-h2200 mk712 ucb1x00"

DOCS=( AUTHORS NEWS README )

src_prepare() {
	# patches come from buildroot + openembedded + suse
	EPATCH_SUFFIX=patch epatch "${WORKDIR}"/patch
	eautoreconf
}

multilib_src_configure() {
	# compile everything. INSTALL_MASK= what you don't want.
	ECONF_SOURCE=${S} \
	econf \
		--enable-linear --enable-dejitter \
		--enable-variance --enable-pthres \
		--enable-input --enable-shared \
		--enable-arctic2 --enable-collie \
		--enable-corgi --enable-h3600 \
		--enable-linear-h2200 --enable-mk712 \
		--enable-ucb1x00 --disable-debug
}
