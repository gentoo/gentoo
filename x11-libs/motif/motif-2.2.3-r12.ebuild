# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/motif/motif-2.2.3-r12.ebuild,v 1.14 2015/01/08 23:23:03 ulm Exp $

EAPI=5

inherit autotools eutils flag-o-matic multilib multilib-minimal

MY_P=openMotif-${PV}
DESCRIPTION="Legacy Open Motif libraries for old binaries"
HOMEPAGE="http://motif.ics.com/"
SRC_URI="ftp://ftp.ics.com/openmotif/2.2/${PV}/src/${MY_P}.tar.gz
	mirror://gentoo/openmotif-${PV}-patches-5.tar.xz"

LICENSE="MOTIF MIT"
SLOT="2.2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="abi_x86_32? ( !app-emulation/emul-linux-x86-motif[-abi_x86_32(-)] )
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXmu-1.1.1-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXp-1.0.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}]"

DEPEND="${RDEPEND}
	x11-libs/libXaw
	x11-misc/xbitmaps"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	EPATCH_SUFFIX=patch epatch
	epatch_user

	# This replaces deprecated, obsoleted and now invalid AC_DEFINE
	# with their proper alternatives.
	sed -i -e 's:AC_DEFINE(\([^)]*\)):AC_DEFINE(\1, [], [\1]):g' \
		configure.in acinclude.m4

	# Build only the libraries
	sed -i -e '/^SUBDIRS/{:x;/\\$/{N;bx;};s/=.*/= lib clients/;}' Makefile.am
	sed -i -e '/^SUBDIRS/{:x;/\\$/{N;bx;};s/=.*/= uil/;}' clients/Makefile.am

	AM_OPTS="--force-missing" eautoreconf

	# get around some LANG problems in make (#15119)
	unset LANG

	# bug #80421
	filter-flags -ftracer

	# feel free to fix properly if you care
	append-flags -fno-strict-aliasing
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf --with-x --disable-static
}

multilib_src_compile() {
	emake -j1
}

multilib_src_install() {
	emake -j1 DESTDIR="${D}" install-exec
}

multilib_src_install_all() {
	# cleanups
	rm -rf "${ED}"/usr/bin
	rm -f "${ED}"/usr/lib*/*.{so,la,a}

	dodoc README RELEASE RELNOTES BUGREPORT TODO
}
