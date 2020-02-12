# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python3_6 )

inherit autotools python-r1

DESCRIPTION="Python wrapper for libcangjie"
HOMEPAGE="http://cangjians.github.io/"
SRC_URI="https://github.com/Cangjians/py${PN}/releases/download/v${PV}/${P#py}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	app-i18n/libcangjie"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	python_configure() {
		ECONF_SOURCE="${S}" econf
	}
	python_foreach_impl run_in_build_dir python_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_test() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	python_foreach_impl run_in_build_dir default
	einstalldocs

	find "${D}" -name '*.la' -delete || die
}
