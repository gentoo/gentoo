# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
PYTHON_REQ_USE="threads"
DISTUTILS_OPTIONAL=true
DISTUTILS_IN_SOURCE_BUILD=true

inherit distutils-r1 eutils versionator

MY_P=libtorrent-rasterbar-${PV} # TODO: rename, bug 576126
MY_PV=$(replace_all_version_separators _)

DESCRIPTION="C++ BitTorrent implementation focusing on efficiency and scalability"
HOMEPAGE="http://libtorrent.org"
SRC_URI="https://github.com/arvidn/libtorrent/releases/download/libtorrent-${MY_PV}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0/9"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug +dht doc examples libressl python +ssl static-libs test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

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

S=${WORKDIR}/${MY_P}

src_prepare() {
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
		$(use_enable debug logging)
		$(use_enable debug disk-stats)
		$(use_enable dht dht $(usex debug logging yes))
		$(use_enable examples)
		$(use_enable ssl encryption)
		$(use_enable static-libs static)
		$(use_enable test tests)
		--with-libiconv
	)
	econf "${myeconfargs[@]}"

	if use python; then
		python_configure() {
			econf "${myeconfargs[@]}" \
				--enable-python-binding \
				--with-boost-python="${EPYTHON#python}"
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

	prune_libtool_files
}
