# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multibuild cmake

DESCRIPTION="A userspace version of libnv ported from FreeBSD"
HOMEPAGE="https://github.com/Zer0-One/libnv-portable"
SRC_URI="https://github.com/Zer0-One/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/1"
KEYWORDS="~amd64"
IUSE="static-libs test"

DEPEND="${RDEPEND}
		test? (
				dev-util/kyua
				dev-libs/atf
		)
"
RDEPEND=">=dev-libs/libbsd-0.10.0:=[static-libs?]"
BDEPEND=">=dev-util/cmake-3.14.6"

RESTRICT="!test? ( test )"

src_prepare() {
	MULTIBUILD_VARIANTS=(shared)
	use static-libs && MULTIBUILD_VARIANTS+=(static)

	cmake_src_prepare
}

src_configure() {
	multibuild_foreach_variant libnv-portable_configure
}

libnv-portable_configure() {
	local mycmakeargs=(
		-DNVP_TEST="$(usex test)"
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DBUILD_SHARED_LIBS=$(
			if [[ ${MULTIBUILD_VARIANT} == shared ]]; then
				echo "ON"
			else
				echo "OFF"
			fi
		)
	)

	cmake_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

# We run the tests once when linked dynamically against libnvp, and then again when linked statically
src_test() {
	multibuild_foreach_variant cmake_src_test
}

src_install() {
	multibuild_foreach_variant cmake_src_install

	doman doc/*.3
}
