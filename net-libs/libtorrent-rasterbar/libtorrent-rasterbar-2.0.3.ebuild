# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_8,3_9} )
PYTHON_REQ_USE="threads(+)"

inherit cmake python-any-r1

DESCRIPTION="C++ BitTorrent implementation focusing on efficiency and scalability"
HOMEPAGE="https://libtorrent.org/ https://github.com/arvidn/libtorrent"
SRC_URI="https://github.com/arvidn/libtorrent/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/2.0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
IUSE="+dht debug gnutls python ssl test"

RESTRICT="!test? ( test ) test"
DEPEND="dev-libs/boost:=[threads]"
RDEPEND="
	python? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-libs/boost[python,${PYTHON_USEDEP}]')
	)
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? ( dev-libs/openssl:= )
	)
	${DEPEND}
"

pkg_setup() {
	use python && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_CXX_STANDARD=14
		-DBUILD_SHARED_LIBS=ON
		-Dbuild_examples=OFF
		-Ddht=$(usex dht ON OFF)
		-Dencryption=$(usex ssl ON OFF)
		-Dgnutls=$(usex gnutls ON OFF)
		-Dlogging=$(usex debug ON OFF)
		-Dpython-bindings=$(usex python ON OFF)
		-Dbuild_tests=$(usex test ON OFF)
	)

	use python && mycmakeargs+=( -Dboost-python-module-name="${EPYTHON}" )

	cmake_src_configure
}
