# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
PYTHON_REQ_USE="threads"
DISTUTILS_OPTIONAL=true
DISTUTILS_IN_SOURCE_BUILD=true

inherit distutils-r1 versionator

MY_PV=$(replace_all_version_separators _)

DESCRIPTION="C++ BitTorrent implementation focusing on efficiency and scalability"
HOMEPAGE="http://libtorrent.org"
SRC_URI="https://github.com/arvidn/libtorrent/releases/download/libtorrent-${MY_PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/8"
KEYWORDS="amd64 arm ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE="debug +dht doc examples +geoip libressl python +ssl static-libs test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="
	dev-libs/boost:=[threads]
	virtual/libiconv
	geoip? ( dev-libs/geoip )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost:=[python,${PYTHON_USEDEP}]
	)
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
"
DEPEND="${COMMON_DEPEND}
	sys-devel/libtool
"
RDEPEND="${COMMON_DEPEND}
	examples? ( !net-p2p/mldonkey )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.9-test_torrent_parse.patch"
	# RC_1_0 branch
	"${FILESDIR}/${P}-fix-abicompat.patch"
	"${FILESDIR}/${P}-move-header.patch"
	# master branch
	"${FILESDIR}/${P}-fix-test_ssl.patch"
	"${FILESDIR}/${P}-boost-config-header.patch"
)

src_prepare() {
	default

	# bug 578026
	# prepend -L${S}/... to ensure bindings link against the lib we just built
	sed -i -e "s|^|-L${S}/src/.libs |" bindings/python/compile_flags.in || die

	use python && distutils-r1_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable debug logging)
		$(use_enable debug statistics)
		$(use_enable debug disk-stats)
		$(use_enable dht dht $(usex debug logging yes))
		$(use_enable examples)
		$(use_enable geoip)
		$(use_with   geoip libgeoip)
		$(use_enable ssl encryption)
		$(use_enable static-libs static)
		$(use_enable test tests)
		--with-libiconv
	)
	econf "${myeconfargs[@]}"

	if use python; then
		myeconfargs+=(
			--enable-python-binding
			--with-boost-python
		)
		python_configure() {
			econf "${myeconfargs[@]}"
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
