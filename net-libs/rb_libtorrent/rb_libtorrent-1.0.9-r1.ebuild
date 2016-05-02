# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
PYTHON_REQ_USE="threads"
DISTUTILS_OPTIONAL=true
DISTUTILS_IN_SOURCE_BUILD=true

inherit autotools distutils-r1 versionator

MY_PV=$(replace_all_version_separators '_' )
S=${WORKDIR}/libtorrent-libtorrent-${MY_PV}

DESCRIPTION="C++ BitTorrent implementation focusing on efficiency and scalability"
HOMEPAGE="http://libtorrent.org"
SRC_URI="https://github.com/arvidn/libtorrent/archive/libtorrent-${MY_PV}.tar.gz -> rb_libtorrent-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug +dht doc examples python +ssl static-libs test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/boost-1.53:=[threads]
	sys-libs/zlib
	virtual/libiconv
	examples? ( !net-p2p/mldonkey )
	ssl? ( dev-libs/openssl:0= )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost:=[python,${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.2"

RESTRICT="test"

src_prepare() {
	default

	# make sure lib search dir points to the main `S` dir and not to python copies
	sed -i "s|-L[^ ]*/src/\.libs|-L${S}/src/.libs|" \
		-- 'bindings/python/link_flags.in' || die

	# needed or else eautoreconf fails
	mkdir build-aux && cp {m4,build-aux}/config.rpath || die

	eautoreconf

	use python && python_copy_sources
}

src_configure() {
	local myeconfargs=(
		--disable-silent-rules # bug 441842
		--with-boost-system=mt
		--with-libiconv
		$(use_enable debug)
		$(usex debug "--enable-logging=verbose" "")
		$(use_enable dht)
		$(use_enable examples)
		$(use_enable ssl encryption)
		$(use_enable static-libs static)
		$(use_enable test tests)
	)
	econf "${myeconfargs[@]}"

	python_configure() {
		local myeconfargs+=(
			--enable-python-binding
			--with-boost-python=yes
		)
		econf "${myeconfargs[@]}"
	}
	use python && distutils-r1_src_configure
}

src_compile() {
	default

	python_compile() {
		cd "${BUILD_DIR}/../bindings/python" || die
		distutils-r1_python_compile
	}
	use python && distutils-r1_src_compile
}

src_install() {
	use doc && HTML_DOCS+=( "${S}"/docs )

	default

	python_install() {
		cd "${BUILD_DIR}/../bindings/python" || die
		distutils-r1_python_install
	}
	use python && distutils-r1_src_install
}
