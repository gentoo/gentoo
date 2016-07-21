# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils flag-o-matic multilib

DESCRIPTION="Library of simple functions that are optimized for various CPUs"
HOMEPAGE="https://liboil.freedesktop.org/"
SRC_URI="https://liboil.freedesktop.org/download/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0.3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+examples static-libs test"

RDEPEND="examples? ( dev-libs/glib:2 )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig"

src_prepare() {
	if ! use examples; then
		sed "s/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/" \
			-i Makefile.am Makefile.in || die
	fi

	if ! use test; then
		sed "s/^\(SUBDIRS =.*\)testsuite\(.*\)$/\1\2/" \
			-i Makefile.am Makefile.in || die
	fi

	epatch "${FILESDIR}/${P}-amd64-cpuid.patch"
	has x32 $(get_all_abis) && epatch "${FILESDIR}"/${PN}-0.3.17-x32.patch
}

src_configure() {
	strip-flags
	filter-flags -O?
	append-flags -O2

	econf $(use_enable static-libs static)
}

src_install() {
	DOCS="AUTHORS BUG-REPORTING HACKING NEWS README"
	default
	prune_libtool_files
}

pkg_postinst() {
	if ! use examples; then
		ewarn "You have disabled examples USE flag. Beware that upstream might"
		ewarn "want the output of some utilities that are only built with"
		ewarn "USE='examples' if you report bugs to them."
	fi
}
