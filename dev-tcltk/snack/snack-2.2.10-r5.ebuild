# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/snack/snack-2.2.10-r5.ebuild,v 1.9 2015/03/20 10:33:59 jlec Exp $

EAPI=4

PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit eutils distutils multilib

DESCRIPTION="The Snack Sound Toolkit (Tcl)"
HOMEPAGE="http://www.speech.kth.se/snack/"
SRC_URI="http://www.speech.kth.se/snack/dist/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
SLOT="0"
IUSE="alsa examples python threads vorbis"

RESTRICT="test" # Bug 78354

DEPEND="
	>dev-lang/tcl-8.4.3:0
	>dev-lang/tk-8.4.3:0
	alsa? ( media-libs/alsa-lib )
	vorbis? ( media-libs/libvorbis )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${PV}/unix"

PYTHON_MODNAME="tkSnack.py"

pkg_setup() {
	if use python; then
		python_pkg_setup
	fi
}

src_prepare() {
	# bug 226137 - snack depends on alsa private symbol _snd_pcm_mmap_hw_ptr
	epatch "${FILESDIR}"/alsa-undef-sym.patch
	# bug 270839 - error from /usr/include/bits/mathcalls.h:310
	sed \
		-e 's|^\(#define roundf(.*\)|//\1|' \
		-i ../generic/jkFormatMP3.c || die

	# adds -install_name (soname on Darwin)
	[[ ${CHOST} == *-darwin* ]] && epatch "${FILESDIR}"/${P}-darwin.patch

	# From Fedora
	cd ../
	epatch "${FILESDIR}"/${P}-CVE-2012-6303-fix.patch
}

src_configure() {
	local myconf="--libdir="${EPREFIX}"/usr/$(get_libdir) --includedir="${EPREFIX}"/usr/include"

	use alsa && myconf="${myconf} --enable-alsa"
	use threads && myconf="${myconf} --enable-threads"

	if use vorbis ; then
		myconf="${myconf} --with-ogg-include="${EPREFIX}"/usr/include"
		myconf="${myconf} --with-ogg-lib="${EPREFIX}"/usr/$(get_libdir)"
	fi

	econf ${myconf}
}

src_compile() {
	# We do not want to run distutils_src_compile
	default
}

src_install() {
	default

	if use python ; then
		cd "${S}"/../python
		distutils_src_install
	fi

	cd "${S}"/..

	dohtml doc/*

	if use examples ; then
		sed -i -e 's/wish[0-9.]+/wish/g' demos/tcl/* || die
		docinto examples/tcl
		dodoc demos/tcl/*

		if use python ; then
			docinto examples/python
			dodoc demos/python/*
		fi
	fi
}

pkg_postinst() {
	use python && distutils_pkg_postinst
}

pkg_postrm() {
	use python && distutils_pkg_postrm
}
