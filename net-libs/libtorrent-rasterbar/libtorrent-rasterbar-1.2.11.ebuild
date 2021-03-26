# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_OPTIONAL=true
DISTUTILS_IN_SOURCE_BUILD=true

inherit autotools flag-o-matic distutils-r1

DESCRIPTION="C++ BitTorrent implementation focusing on efficiency and scalability"
HOMEPAGE="https://libtorrent.org https://github.com/arvidn/libtorrent"
SRC_URI="https://github.com/arvidn/libtorrent/archive/v${PV}.tar.gz -> libtorrent-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0/10"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~sparc x86"
IUSE="debug +dht doc examples libressl python +ssl static-libs test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="!test? ( test )"

S="${WORKDIR}/libtorrent-${PV}"

RDEPEND="
	dev-libs/boost:=[threads]
	virtual/libiconv
	examples? ( !net-p2p/mldonkey )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost:=[python,${PYTHON_USEDEP}]
	)
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
"
DEPEND="${RDEPEND}
	sys-devel/libtool
"

src_prepare() {
	mkdir -p "${S}"/build-aux || die
	touch "${S}"/build-aux/config.rpath || die
	append-cxxflags -std=c++14
	eautoreconf

	default

	# bug 578026
	# prepend -L${S}/... to ensure bindings link against the lib we just built
	sed -i -e "s|^|-L${S}/src/.libs |" bindings/python/link_flags.in || die

	# prepend -I${S}/... to ensure bindings use the right headers
	sed -i -e "s|^|-I${S}/src/include |" bindings/python/compile_flags.in || die

	use python && distutils-r1_src_prepare
}

src_configure() {

	local myeconfargs=(
		$(use_enable debug)
		$(use_enable debug export-all)
		$(use_enable debug logging)
		$(use_enable dht)
		$(use_enable examples)
		$(use_enable ssl encryption)
		$(use_enable static-libs static)
		$(use_enable test tests)
		--with-boost="${ESYSROOT}/usr"
		--with-libiconv
		--enable-logging
	)
	econf "${myeconfargs[@]}"

	if use python; then
		python_configure() {
			econf "${myeconfargs[@]}" \
				--enable-python-binding \
				--with-boost-python="boost_${EPYTHON/./}"
				# git rid of c++11
				sed s/-std=c++11//g < bindings/python/compile_cmd > bindings/python/compile_cmd.new || die
				mv -f bindings/python/compile_cmd.new bindings/python/compile_cmd || die
		}
		distutils-r1_src_configure
	fi
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

	find "${D}" -name '*.la' -delete || die
}
