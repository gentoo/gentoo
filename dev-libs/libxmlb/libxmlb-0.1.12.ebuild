# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit meson python-any-r1

DESCRIPTION="Library to help create and query binary XML blobs"
HOMEPAGE="https://github.com/hughsie/libxmlb"
SRC_URI="https://github.com/hughsie/libxmlb/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="doc introspection stemmer test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	sys-apps/util-linux
	stemmer? ( dev-libs/snowball-stemmer )
"

DEPEND="
	${RDEPEND}
	doc? ( dev-util/gtk-doc )
	introspection? ( dev-libs/gobject-introspection )
"

BDEPEND="
	>=dev-util/meson-0.47.0
	virtual/pkgconfig
	introspection? (
		$(python_gen_any_dep 'dev-python/setuptools[${PYTHON_USEDEP}]')
		${PYTHON_DEPS}
	)
"

python_check_deps() {
	has_version -b "dev-python/setuptools[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use introspection && python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Dgtkdoc="$(usex doc true false)"
		-Dintrospection="$(usex introspection true false)"
		-Dstemmer="$(usex stemmer true false)"
		-Dtests="$(usex test true false)"
	)
	meson_src_configure
}
