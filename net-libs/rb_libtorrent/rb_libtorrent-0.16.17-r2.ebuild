# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/rb_libtorrent/rb_libtorrent-0.16.17-r2.ebuild,v 1.5 2015/04/12 17:21:04 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )
PYTHON_REQ_USE="threads"
DISTUTILS_OPTIONAL=true
AUTOTOOLS_AUTORECONF=true

inherit autotools-utils multilib distutils-r1

MY_P=${P/rb_/}
MY_P=${MY_P/torrent/torrent-rasterbar}
S=${WORKDIR}/${MY_P}

DESCRIPTION="C++ BitTorrent implementation focusing on efficiency and scalability"
HOMEPAGE="http://www.rasterbar.com/products/libtorrent/"
SRC_URI="mirror://sourceforge/libtorrent/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc examples python ssl static-libs test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/boost-1.48:=[threads]
	sys-libs/zlib
	examples? ( !net-p2p/mldonkey )
	ssl? ( dev-libs/openssl:0= )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost[python,${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.2"

RESTRICT="test"

PATCHES=( "${FILESDIR}"/${P}-python.patch )

src_configure() {
	local myeconfargs=(
		--disable-silent-rules # bug 441842
		--with-boost-libdir=/usr/$(get_libdir)
		$(use_enable debug)
		$(use_enable test tests)
		$(use_enable examples)
		$(use_enable ssl encryption)
		$(use_enable python python-binding)
		$(usex debug "--enable-logging=verbose" "")
	)

	use python && python_setup

	autotools-utils_src_configure
	use python && cd "${BUILD_DIR}"/bindings/python && distutils-r1_src_configure
}

src_compile() {
	autotools-utils_src_compile
	use python && cd "${BUILD_DIR}"/bindings/python && distutils-r1_src_compile
}

src_install() {
	use doc && HTML_DOCS=( docs/. )

	autotools-utils_src_install
	use python && cd "${BUILD_DIR}"/bindings/python && distutils-r1_src_install
}
