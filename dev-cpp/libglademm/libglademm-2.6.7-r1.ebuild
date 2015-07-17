# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libglademm/libglademm-2.6.7-r1.ebuild,v 1.9 2015/07/17 15:32:28 ago Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2 multilib-minimal

DESCRIPTION="C++ bindings for libglade"
HOMEPAGE="http://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="2.4"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 ~sh ~sparc x86 ~x86-fbsd"
IUSE="doc examples"

COMMON_DEPEND="
	>=gnome-base/libglade-2.6.4-r1:2.0[${MULTILIB_USEDEP}]
	>=dev-cpp/gtkmm-2.24.3:2.4[${MULTILIB_USEDEP}]
	>=dev-cpp/glibmm-2.34.1:2[${MULTILIB_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-gtkmmlibs-20140508
		!app-emulation/emul-linux-x86-gtkmmlibs[-abi_x86_32(-)] )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

src_prepare() {
	# we will control install manually in install
	sed -i 's/^\(SUBDIRS =.*\)docs\(.*\)$/\1\2/' Makefile.am Makefile.in || \
		die "sed Makefile.{am,in} failed (1)"

	# don't waste time building the examples
	sed -i 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' \
		Makefile.am Makefile.in || die "sed Makefile.{am,in} failed (2)"

	gnome2_src_prepare
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" gnome2_src_configure
}

multilib_src_compile() {
	gnome2_src_compile

	if multilib_is_native_abi && use doc; then
		emake -C "docs/reference" all || die "emake doc failed"
	fi
}

multilib_src_install() {
	gnome2_src_install

	if use examples; then
		emake -C "examples" distclean || die "examples clean up failed"
	fi
}

multilib_src_install_all() {
	einstalldocs

	if use doc ; then
		dohtml -r docs/reference/html/*
	fi

	if use examples; then
		find "${S}/examples" -name "Makefile*" -delete \
			|| die "examples cleanup failed"
		insinto "/usr/share/doc/${PF}"
		doins -r examples || die "doins failed"
	fi
}
