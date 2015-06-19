# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmad/libmad-0.15.1b-r8.ebuild,v 1.11 2015/03/03 08:42:56 dlan Exp $

EAPI=5

inherit eutils autotools libtool flag-o-matic multilib-minimal

DESCRIPTION="\"M\"peg \"A\"udio \"D\"ecoder library"
HOMEPAGE="http://mad.sourceforge.net"
SRC_URI="mirror://sourceforge/mad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="debug static-libs"

DEPEND=""
RDEPEND="abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20130224-r3
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"

DOCS=( CHANGES CREDITS README TODO VERSION )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/mad.h
)

src_prepare() {
	epatch \
		"${FILESDIR}"/libmad-0.15.1b-cflags.patch \
		"${FILESDIR}"/libmad-0.15.1b-cflags-O2.patch \
		"${FILESDIR}"/libmad-0.15.1b-gcc44-mips-h-constraint-removal.patch

	# bug 467002
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' configure.ac || die

	eautoreconf
	# unnecessary when eautoreconf'd
#	elibtoolize
	# unnecessary when eautoreconf'd with new autoconf, for example, 2.69
#	epunt_cxx #74490
}

multilib_src_configure() {
	local myconf="--enable-accuracy"
	# --enable-speed		 optimize for speed over accuracy
	# --enable-accuracy		 optimize for accuracy over speed
	# --enable-experimental	 enable code using the EXPERIMENTAL
	#						 preprocessor define

	# Fix for b0rked sound on sparc64 (maybe also sparc32?)
	# default/approx is also possible, uses less cpu but sounds worse
	use sparc && myconf+=" --enable-fpm=64bit"

	[[ $(tc-arch) == "amd64" ]] && myconf+=" --enable-fpm=64bit"
	[[ $(tc-arch) == "x86" ]] && myconf+=" --enable-fpm=intel"
	[[ $(tc-arch) == "ppc" ]] && myconf+=" --enable-fpm=default"
	[[ $(tc-arch) == "ppc64" ]] && myconf+=" --enable-fpm=64bit"

	ECONF_SOURCE="${S}" econf \
		$(use_enable debug debugging) \
		$(use_enable static-libs static) \
		${myconf}
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	# This file must be updated with each version update
	insinto /usr/$(get_libdir)/pkgconfig
	doins "${FILESDIR}"/mad.pc

	# Use correct libdir in pkgconfig file
	sed -i -e "s:^libdir.*:libdir=${EPREFIX}/usr/$(get_libdir):" \
		"${ED}"/usr/$(get_libdir)/pkgconfig/mad.pc

	prune_libtool_files --all
}
