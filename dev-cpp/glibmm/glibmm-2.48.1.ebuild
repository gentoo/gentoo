# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils gnome2 multilib-minimal

DESCRIPTION="C++ interface for glib2"
HOMEPAGE="http://www.gtkmm.org"

LICENSE="LGPL-2.1+ GPL-2+" # GPL-2+ applies only to the build system
SLOT="2"
KEYWORDS="alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="doc debug examples test"

RDEPEND="
	>=dev-libs/libsigc++-2.8.0:2[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.48.0:2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
# dev-cpp/mm-common needed for eautoreconf

src_prepare() {
	if ! use test; then
		# don't waste time building tests
		sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' \
			-i Makefile.am Makefile.in || die "sed 1 failed"
	fi

	# don't build examples - we want to install example sources, not binaries
	sed 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' \
		-i Makefile.am Makefile.in || die "sed 2 failed"

	gnome2_src_prepare
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" gnome2_src_configure \
		$(use_enable debug debug-refcounting) \
		$(multilib_native_use_enable doc documentation) \
		--enable-deprecated-api
}

multilib_src_test() {
	cd tests
	default

	for i in */test; do
		${i} || die "Running tests failed at ${i}"
	done
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	einstalldocs

	if ! use doc && ! use examples; then
		rm -fr "${ED}usr/share/doc/glibmm*"
	fi

	if use examples; then
		find examples -type d -name '.deps' -exec rm -rf {} \; 2>/dev/null
		dodoc -r examples
	fi
}
