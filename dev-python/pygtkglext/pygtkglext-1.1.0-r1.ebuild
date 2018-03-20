# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_PRUNE_LIBTOOL_FILES=modules
PYTHON_COMPAT=( python2_7 )

inherit autotools-utils python-r1

DESCRIPTION="Python bindings to GtkGLExt"
HOMEPAGE="https://projects-old.gnome.org/gtkglext/"
SRC_URI="mirror://sourceforge/gtkglext/${P}.tar.bz2"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/pygtk-2.8:2[${PYTHON_USEDEP}]
	>=dev-libs/glib-2.0:2
	>=x11-libs/gtk+-2.0:2
	>=x11-libs/gtkglext-1.0.0
	dev-python/pyopengl[${PYTHON_USEDEP}]
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	python_foreach_impl autotools-utils_src_configure
}

src_compile() {
	python_foreach_impl autotools-utils_src_compile
}

src_test() {
	python_foreach_impl autotools-utils_src_test
}

src_install() {
	python_foreach_impl autotools-utils_src_install

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc examples/*.{py,png}
	fi
}
