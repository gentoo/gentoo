# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit meson python-any-r1

DESCRIPTION="Library to help create and query binary XML blobs"
HOMEPAGE="https://github.com/hughsie/libxmlb"
SRC_URI="https://github.com/hughsie/libxmlb/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1+"
SLOT="0/2" # libxmlb.so version

KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc introspection stemmer test"

RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/xz-utils
	dev-libs/glib:2
	sys-apps/util-linux
	stemmer? ( dev-libs/snowball-stemmer:= )
"

DEPEND="
	${RDEPEND}
	doc? ( dev-util/gtk-doc )
	introspection? ( dev-libs/gobject-introspection )
"

BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/meson-0.47.0
	virtual/pkgconfig
	introspection? (
		$(python_gen_any_dep 'dev-python/setuptools[${PYTHON_USEDEP}]')
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.9-no_installed_tests.patch
)

python_check_deps() {
	has_version -b "dev-python/setuptools[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use doc gtkdoc)
		$(meson_use introspection)
		$(meson_use stemmer)
		$(meson_use test tests)
	)
	meson_src_configure
}
