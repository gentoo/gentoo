# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit eutils python-r1

DESCRIPTION="Python bindings for libraries/plugins for compizconfig-settings"
HOMEPAGE="https://github.com/compiz-reloaded"
SRC_URI="https://github.com/compiz-reloaded/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="${PYTHON_DEPS}
	dev-python/cython[${PYTHON_USEDEP}]
	>=dev-libs/glib-2.6
	>=x11-libs/libcompizconfig-0.6.99
	<x11-libs/libcompizconfig-0.9
"

DEPEND="${RDEPEND}
	virtual/pkgconfig
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_configure() {
	local myeconfargs=(
		--enable-fast-install
		--disable-static
	)
	python_foreach_impl default
}

src_compile() {
	python_foreach_impl default
}

src_install() {
	python_foreach_impl default
	find "${D}" -name '*.la' -delete || die
}
