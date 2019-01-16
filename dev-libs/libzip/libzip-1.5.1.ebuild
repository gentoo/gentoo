# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Library for manipulating zip archives"
HOMEPAGE="https://nih.at/libzip/"
SRC_URI="https://www.nih.at/libzip/${P}.tar.xz"

LICENSE="BSD"
SLOT="0/5"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="static-libs bzip2 gnutls openssl"

RDEPEND="
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	gnutls? ( net-libs/gnutls )
	openssl? ( dev-libs/openssl:0= )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.5.1-bzip2.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_BZIP2=$(usex bzip2)
		-DENABLE_GNUTLS=$(usex gnutls)
		-DENABLE_OPENSSL=$(usex openssl)
	)
	cmake-utils_src_configure

	if use static-libs ; then
		# Upstream doesn't support building dynamic & static
		# simultaneously: https://github.com/nih-at/libzip/issues/76
		mycmakeargs+=(-DBUILD_SHARED_LIBS=no)
		STATIC_BUILD_DIR="${BUILD_DIR}-static"
		BUILD_DIR=${STATIC_BUILD_DIR} cmake-utils_src_configure
	fi
}

src_compile() {
	cmake-utils_src_compile
	use static-libs && BUILD_DIR=${STATIC_BUILD_DIR} cmake-utils_src_compile
}

src_install() {
	# Have to install static-libs first so dynamic files override.
	use static-libs && BUILD_DIR=${STATIC_BUILD_DIR} cmake-utils_src_install
	cmake-utils_src_install
}
