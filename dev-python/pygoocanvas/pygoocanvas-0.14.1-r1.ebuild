# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"
PYTHON_COMPAT=(python2_7 )

inherit gnome2 python-r1

DESCRIPTION="GooCanvas python bindings"
HOMEPAGE="https://live.gnome.org/PyGoocanvas"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="doc examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/pygobject-2.11.3:2[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.10.4:2[${PYTHON_USEDEP}]
	>=dev-python/pycairo-1.8.4[${PYTHON_USEDEP}]
	>=x11-libs/goocanvas-0.14:0
"
DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.4 )
	virtual/pkgconfig
"

src_prepare() {
	prepare_binding() {
		mkdir -p "${BUILD_DIR}" || die
	}
	python_foreach_impl prepare_binding
}

src_configure() {
	# docs installs gtk-doc and xsltproc is not actually used
	configure_binding() {
		ECONF_SOURCE="${S}" gnome2_src_configure \
			$(use_enable doc docs) \
			XSLTPROC=$(type -P true)
	}
	python_foreach_impl run_in_build_dir configure_binding
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome2_src_compile
}

src_test() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	python_foreach_impl run_in_build_dir gnome2_src_install

	dodoc AUTHORS ChangeLog* NEWS

	if use examples; then
		rm demo/Makefile* || die
		cp -R demo "${D}"/usr/share/doc/${PF} || die
	fi
}

run_in_build_dir() {
	pushd "${BUILD_DIR}" > /dev/null || die
	"$@"
	popd > /dev/null
}
