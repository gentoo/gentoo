# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"

inherit flag-o-matic gnome2 multilib-minimal

DESCRIPTION="C++ bindings for libglade"
HOMEPAGE="https://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="2.4"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="doc examples"

RDEPEND="
	>=gnome-base/libglade-2.6.4-r1:2.0[${MULTILIB_USEDEP}]
	>=dev-cpp/gtkmm-2.24.3:2.4[${MULTILIB_USEDEP}]
	>=dev-cpp/glibmm-2.34.1:2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	# we will control install manually in install
	sed -i 's/^\(SUBDIRS =.*\)docs\(.*\)$/\1\2/' Makefile.am Makefile.in || \
		die "sed Makefile.{am,in} failed (1)"

	# don't waste time building the examples
	sed -i 's/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/' \
		Makefile.am Makefile.in || die "sed Makefile.{am,in} failed (2)"

	append-cxxflags -std=c++11 #566584

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
