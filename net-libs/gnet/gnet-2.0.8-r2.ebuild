# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit autotools eutils gnome2

DESCRIPTION="A simple network library"
HOMEPAGE="https://live.gnome.org/GNetLibrary"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="test"

# FIXME: automagic use of valgrind
RDEPEND=">=dev-libs/glib-2.6:2"
DEPEND="${RDEPEND}
	>=dev-libs/check-0.9.11
	>=dev-util/gtk-doc-am-1.2
	virtual/pkgconfig
"
# FIXME: check should only be needed with USE 'test', bug #349301
#	test? ( >=dev-libs/check-0.9.7 )"

src_prepare() {
	# Do not leak main context reference, from master
	epatch "${FILESDIR}"/${PN}-2.0.8-context-leak.patch

	# Fix usage of check framework, bug #296849, from master
	epatch "${FILESDIR}"/${PN}-2.0.8-check-usage-update.patch

	# ifdef around network tests code, refs. bug #320759
	epatch "${FILESDIR}"/${PN}-2.0.8-network-tests.patch

	# Do not hardcode glib patch in pkgconfig file, debian bug #652165
	epatch "${FILESDIR}"/${PN}-2.0.8-fix-pkgconfig-abuse.patch

	# Compatibility with recent check releases, bug #498046
	epatch "${FILESDIR}"/${PN}-2.0.8-unittest-build.patch

	# gnetlibrary.org has been adandoned, from master
	epatch "${FILESDIR}"/${PN}-2.0.8-test-existing-domain.patch

	# Do not depend on a running HTTP server on port 80 for unittest
	epatch "${FILESDIR}"/${PN}-2.0.8-unittest-service.patch

	# Do not pass silly cflags with USE=debug, bug #320759
	sed -i \
		-e 's:-Werror::' \
		-e '/AM_PROG_CC_STDC/d' \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:g' \
		configure.ac || die

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS BUGS ChangeLog HACKING NEWS README* TODO"
	# Do not enable network tests in an ebuild environment
	gnome2_src_configure \
		--disable-static \
		--disable-network-tests
}
