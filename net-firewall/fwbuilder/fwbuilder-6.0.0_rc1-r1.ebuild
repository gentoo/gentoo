# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake virtualx

DESCRIPTION="A firewall management GUI for iptables, PF, Cisco routers and more"
HOMEPAGE="https://github.com/fwbuilder/fwbuilder"
SRC_URI="https://github.com/fwbuilder/fwbuilder/archive/refs/tags/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P/_/-}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test ) test"

RDEPEND="
	dev-libs/libxml2:=
	dev-libs/libxslt
	dev-libs/openssl
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	net-analyzer/net-snmp
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )"

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.0_pre20200502-drop-Werror.patch
	"${FILESDIR}"/${PN}-6.0.0_rc1-automagic-ccache.patch
	"${FILESDIR}"/${P}-fix_version.patch
)

src_prepare() {
	# Hangs
	sed -i \
		-e '/add_subdirectory(.*Dialog.*Test)/d' \
		-e '/add_subdirectory(RuleSetViewTest)/d' \
		-e '/add_subdirectory(ObjectManipulatorTest)/d' \
		-e '/add_subdirectory(RuleSetViewContextMenuTest)/d' \
		src/unit_tests/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	cp "${BUILD_DIR}"/src/libfwbuilder/etc/fwbuilder.dtd "${S}"/src/res || die
	TEST_VERBOSE=1 FWB_RES_DIR="${S}/src/res" virtx cmake_src_test
}

src_install() {
	cmake_src_install
	docompress -x /usr/share/man
}
