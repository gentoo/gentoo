# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit multilib-minimal python-single-r1

DESCRIPTION="Codec for karaoke and text encapsulation for Ogg"
HOMEPAGE="https://code.google.com/p/libkate/"
SRC_URI="https://libkate.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"

IUSE="debug doc wxwidgets"
REQUIRED_USE="wxwidgets? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="
	media-libs/libogg:=[${MULTILIB_USEDEP}]
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	sys-devel/flex[${MULTILIB_USEDEP}]
	sys-devel/bison
	doc? ( app-doc/doxygen )
"
RDEPEND="${COMMON_DEPEND}
	wxwidgets? (
		${PYTHON_DEPS}
		dev-python/wxpython:3.0[${PYTHON_USEDEP}]
		media-libs/liboggz )
"

pkg_setup() {
	use wxwidgets && python-single-r1_pkg_setup
}

multilib_src_configure() {
	local ECONF_SOURCE=${S}
	econf \
		--disable-static \
		$(use_enable debug) \
		$(multilib_native_use_enable doc) \
		$(multilib_native_usex wxwidgets '' 'PYTHON=:')
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
	use wxwidgets && python_fix_shebang "${D}"
}
