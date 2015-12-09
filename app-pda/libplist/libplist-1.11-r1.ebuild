# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
# ac_python_devel.m4 is broken with python3
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1

DESCRIPTION="Support library to deal with Apple Property Lists (Binary & XML)"
HOMEPAGE="http://www.libimobiledevice.org/"
SRC_URI="http://www.libimobiledevice.org/downloads/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0/2" # based on SONAME of libplist.so
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-fbsd"
IUSE="python static-libs"

RDEPEND=">=dev-libs/libxml2-2.7.8"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	python? (
		${PYTHON_DEPS}
		>=dev-python/cython-0.17[${PYTHON_USEDEP}]
		)"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DOCS=( AUTHORS NEWS README )

RESTRICT="test" # TODO: src_test() was dropped from 1.10 (cmake) -> 1.11 (autotools)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local myeconfargs=( $(use_enable static-libs static) )
	use python || myeconfargs+=( --without-cython )

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake -j1 #406365
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	if use python; then
		insinto /usr/include/plist/cython
		doins cython/plist.pxd
	fi
}
