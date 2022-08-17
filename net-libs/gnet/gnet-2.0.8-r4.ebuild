# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME2_EAUTORECONF="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2

DESCRIPTION="A simple network library"
HOMEPAGE="https://wiki.gnome.org/Projects/GNetLibrary"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

# FIXME: automagic use of valgrind
RDEPEND=">=dev-libs/glib-2.6:2"
# FIXME: check should only be needed with USE 'test', bug #349301
#	test? ( >=dev-libs/check-0.9.7 )"
DEPEND="${RDEPEND}
	>=dev-libs/check-0.9.11"
BDEPEND="
	>=dev-util/gtk-doc-am-1.2
	virtual/pkgconfig"

PATCHES=(
	# Do not leak main context reference, from master
	"${FILESDIR}"/${PN}-2.0.8-context-leak.patch

	# Fix usage of check framework, bug #296849, from master
	# Disable this patch, bug 698654
	# "${FILESDIR}"/${PN}-2.0.8-check-usage-update.patch

	# ifdef around network tests code, refs. bug #320759
	"${FILESDIR}"/${PN}-2.0.8-network-tests.patch

	# Do not hardcode glib patch in pkgconfig file, debian bug #652165
	"${FILESDIR}"/${PN}-2.0.8-fix-pkgconfig-abuse.patch

	# Compatibility with recent check releases, bug #498046
	"${FILESDIR}"/${PN}-2.0.8-unittest-build.patch

	# gnetlibrary.org has been adandoned, from master
	"${FILESDIR}"/${PN}-2.0.8-test-existing-domain.patch

	# Do not depend on a running HTTP server on port 80 for unittest
	"${FILESDIR}"/${PN}-2.0.8-unittest-service.patch

	# Do not pass silly cflags with USE=debug, bug #320759, #672170
	"${FILESDIR}"/${PN}-2.0.8-autotools.patch
)

src_configure() {
	# Do not enable network tests in an ebuild environment
	gnome2_src_configure \
		--disable-static \
		--disable-network-tests
}
