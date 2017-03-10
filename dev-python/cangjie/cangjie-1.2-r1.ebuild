# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5,3_6} )

inherit autotools python-r1

DESCRIPTION="The Python bindings to libcangjie"
HOMEPAGE="http://cangjians.github.io"
SRC_URI="https://github.com/Cangjians/pycangjie/releases/download/v${PV}/cangjie-${PV}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	app-i18n/libcangjie
	${PYTHON_DEPS}"
DEPEND="
	${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-cython-022.patch" )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	myeconf() {
		ECONF_SOURCE="${S}" econf PYTHON="${PYTHON}"
	}
	python_foreach_impl run_in_build_dir myeconf
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

	# package only installs python modules
	find "${D}" -name '*.la' -delete || die
}
