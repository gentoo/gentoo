# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2 multilib-minimal

DESCRIPTION="C++ bindings for libglade"
HOMEPAGE="https://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="2.4"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="doc examples"

RDEPEND="
	>=gnome-base/libglade-2.6.4-r1:2.0[${MULTILIB_USEDEP}]
	>=dev-cpp/gtkmm-2.24.3:2.4[${MULTILIB_USEDEP}]
	>=dev-cpp/glibmm-2.34.1:2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

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

	multilib_is_native_abi && use doc && emake -C docs/reference all
}

multilib_src_install() {
	gnome2_src_install

	use examples && emake -C examples distclean
}

multilib_src_install_all() {
	use doc && HTML_DOCS=( docs/reference/html/. )
	einstalldocs

	if use examples; then
		find examples/ -name 'Makefile*' -delete \
			|| die "examples cleanup failed"
		dodoc -r examples
	fi
}
