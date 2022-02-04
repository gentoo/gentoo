# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="High-level CPP Binding for ZeroMQ"
HOMEPAGE="https://github.com/zeromq/cppzmq"
SRC_URI="https://github.com/zeromq/${PN}/archive/v${PV}.tar.gz ->  ${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~arm ~arm64 x86 ~x86-linux"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=net-libs/zeromq-4.3.1"
# Tests require cmake modules from catch2 and headers from older version of catch
DEPEND="${RDEPEND}
	test? ( >=dev-cpp/catch-2.5.0
		<dev-cpp/catch-2
	)"

PATCHES=(
	"${FILESDIR}/${PN}-disable-static.patch"
	"${FILESDIR}/${PN}-use-system-catch2.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCPPZMQ_CMAKECONFIG_INSTALL_DIR="/usr/$(get_libdir)/cmake/${PN}/"
		-DCPPZMQ_BUILD_TESTS="$(usex test)"
	)
	if has_version -d '>=net-libs/zeromq-4.3.1[drafts]'; then
		mycmakeargs+=( -DENABLE_DRAFTS=on )
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install
	einstalldocs
}
