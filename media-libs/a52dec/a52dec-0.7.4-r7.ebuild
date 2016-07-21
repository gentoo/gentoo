# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils flag-o-matic multilib-minimal

DESCRIPTION="library for decoding ATSC A/52 streams used in DVD"
HOMEPAGE="http://liba52.sourceforge.net/"
SRC_URI="http://liba52.sourceforge.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="djbfft oss static-libs"

RDEPEND="djbfft? ( >=sci-libs/djbfft-0.76-r2[${MULTILIB_USEDEP}] )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20130224-r8
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}"
DOCS=( AUTHORS ChangeLog HISTORY NEWS README TODO doc/liba52.txt )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-freebsd.patch \
		"${FILESDIR}"/${P}-tests-optional.patch \
		"${FILESDIR}"/${P}-test-hidden-symbols.patch

	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.in || die #466978

	eautoreconf

	filter-flags -fprefetch-loop-arrays
}

multilib_src_configure() {
	local myconf
	use oss || myconf="${myconf} --disable-oss"

	ECONF_SOURCE="${S}" econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable djbfft) \
		${myconf}

	# remove useless subdirs
	if ! multilib_is_native_abi ; then
		sed -i \
			-e 's/ src//' \
			-e 's/ libao//' \
			Makefile || die
	fi
}

multilib_src_compile() {
	emake CFLAGS="${CFLAGS}"
}

multilib_src_install_all() {
	prune_libtool_files --all
	einstalldocs
}
