# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edo edos2unix

LWIP_BASE_S="${WORKDIR}"/${P%_p*}
LWIP_POSIX_S="${LWIP_BASE_S}"/contrib/ports/unix/posixlib
LWIP_TEST_S="${LWIP_BASE_S}"/contrib/ports/unix/check

DESCRIPTION="Small independent implementation of the TCP/IP protocol suite"
HOMEPAGE="https://savannah.nongnu.org/projects/lwip/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="
		https://https.git.savannah.gnu.org/git/lwip.git
		https://github.com/lwip-tcpip/lwip
	"
	inherit git-r3
else
	SRC_URI="mirror://nongnu/${PN}/${P%_p*}.zip"

	if [[ ${PV} == *_p* ]] ; then
		LWIP_PV=+dfsg1-${PV#*_p}
		SRC_URI+=" mirror://debian/pool/main/l/${PN}/${PN}_${PV%_p*}${LWIP_PV}.debian.tar.xz"
	fi

	KEYWORDS="~amd64 ~x86"
fi

S="${LWIP_POSIX_S}"

LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-libs/check
		dev-python/python-subunit
	)
"
BDEPEND="app-arch/unzip"

# Patches to be applied at LWIP_BASE_S, not LWIP_POSIX_S
BASE_PATCHES=(
	"${FILESDIR}"/${PN}-2.2.1-fix-tests-use-lwip-helpers.patch
)

src_prepare() {
	cd "${LWIP_BASE_S}" || die
	# The .zips produced by upstream have Windows line-endings, but
	# the Debian patches don't. But always do this for consistency
	# for user patches.
	edos2unix $(find "${LWIP_BASE_S}" -type 'f' || die)
	if [[ ${PV} == *_p* ]] ; then
		BASE_PATCHES+=( $(awk '{print $1}' "${WORKDIR}"/debian/patches/series | sed -e '/^#/d' -e "s:^:${WORKDIR}/debian/patches/:") )
	fi
	eapply "${BASE_PATCHES[@]}"
	sed -i -e 's:-Werror::' \
		contrib/ports/CMakeCommon.cmake \
		contrib/ports/Common.allports.mk || die
	sed -i -e '/LWIP_USE_SANITIZERS/d' \
		contrib/ports/unix/check/CMakeLists.txt || die

	cd "${LWIP_POSIX_S}" || die
	cmake_src_prepare

	if use test ; then
		CMAKE_USE_DIR="${LWIP_TEST_S}" BUILD_DIR="${WORKDIR}"/${P}_build/test cmake_src_prepare
	fi
}

src_configure() {
	cmake_src_configure
	if use test ; then
		CMAKE_USE_DIR="${LWIP_TEST_S}" BUILD_DIR="${WORKDIR}"/${P}_build/test cmake_src_configure
	fi
}

src_compile() {
	cmake_src_compile
	if use test ; then
		CMAKE_USE_DIR="${LWIP_TEST_S}" BUILD_DIR="${WORKDIR}"/${P}_build/test cmake_src_compile
	fi
}

src_test() {
	CMAKE_USE_DIR="${LWIP_TEST_S}" BUILD_DIR="${WORKDIR}"/${P}_build/test cmake_src_test
	edo "${WORKDIR}"/${P}_build/test/lwip_unittests
}
