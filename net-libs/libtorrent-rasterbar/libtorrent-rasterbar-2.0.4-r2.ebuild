# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_8,3_9} )

inherit cmake python-single-r1

DESCRIPTION="C++ BitTorrent implementation focusing on efficiency and scalability"
HOMEPAGE="https://libtorrent.org/ https://github.com/arvidn/libtorrent"
SRC_URI="https://github.com/arvidn/libtorrent/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/2.0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
IUSE="+dht debug gnutls python ssl test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="!test? ( test ) test" # not yet fixed
DEPEND="
	dev-libs/boost:=[threads(+)]
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-libs/boost[python,${PYTHON_USEDEP}]
		')
	)
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? ( dev-libs/openssl:= )
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-boost-1.77.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
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

	# We need to drop the . from the Python version to satisfy Boost's
	# FindBoost.cmake module, bug #793038.
	use python && mycmakeargs+=( -Dboost-python-module-name="${EPYTHON/./}" )

	cmake_src_configure
}
