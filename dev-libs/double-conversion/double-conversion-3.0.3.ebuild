# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils multibuild

DESCRIPTION="Binary-decimal and decimal-binary conversion routines for IEEE doubles"
HOMEPAGE="https://github.com/google/double-conversion"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="amd64 arm ~arm64 hppa ~mips ppc ~ppc64 sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
IUSE="static-libs test"

pkg_setup() {
	MULTIBUILD_VARIANTS=( shared $(usev static-libs) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=( -DBUILD_TESTING=$(usex test) )
		if [[ ${MULTIBUILD_VARIANT} = shared ]]; then
			mycmakeargs+=( -DBUILD_SHARED_LIBS=ON )
		fi
		if [[ ${MULTIBUILD_VARIANT} = static-libs ]]; then
			mycmakeargs+=( -DBUILD_SHARED_LIBS=OFF )
		fi

		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_test() {
	[[ ${MULTIBUILD_VARIANT} = shared ]] && cmake-utils_src_test
}

src_install() {
	myinstall() {
		[[ ${MULTIBUILD_VARIANT} = shared ]] && cmake-utils_src_install
		[[ ${MULTIBUILD_VARIANT} = static-libs ]] && \
			dolib.a ${BUILD_DIR}/double-conversion/libdouble-conversion.a
	}

	multibuild_foreach_variant myinstall
}
