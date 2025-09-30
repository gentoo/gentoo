# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=8013c00e1f29350d96926768290e8c7f91cda424
inherit cmake xdg

DESCRIPTION="Firewall management GUI for iptables, PF, Cisco routers and more"
HOMEPAGE="https://github.com/fwbuilder/fwbuilder"
SRC_URI="https://github.com/fwbuilder/fwbuilder/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test ) test"

RDEPEND="
	dev-libs/libxml2:=
	dev-libs/libxslt
	dev-libs/openssl:=
	dev-qt/qtbase:6[gui,network,widgets]
	net-analyzer/net-snmp
"
DEPEND="${RDEPEND}"

PATCHES=(
	# downstream patches
	"${FILESDIR}"/${PN}-6.0.0_pre20200502-drop-Werror.patch
	"${FILESDIR}"/${PN}-6.0.0_rc1-automagic-ccache.patch
	"${FILESDIR}"/${PN}-6.0.0_rc1-fix_version.patch
	"${FILESDIR}"/${P}-docdir-nocompress.patch # bug 957888
)

src_prepare() {
	# Hangs
	sed -i \
		-e '/add_subdirectory(.*Dialog.*Test)/s/^/# removed by Gentoo: &/' \
		-e '/add_subdirectory(RuleSetViewTest)/s/^/# removed by Gentoo: &/' \
		-e '/add_subdirectory(ObjectManipulatorTest)/s/^/# removed by Gentoo: &/' \
		-e '/add_subdirectory(RuleSetViewContextMenuTest)/s/^/# removed by Gentoo: &/' \
		src/unit_tests/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUseQt6=ON
		-DFWB_INSTALL_DOCDIR=
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	cp "${BUILD_DIR}"/src/libfwbuilder/etc/fwbuilder.dtd "${S}"/src/res || die

	local -x QT_QPA_PLATFORM=offscreen
	TEST_VERBOSE=1 FWB_RES_DIR="${S}/src/res" cmake_src_test
}

src_install() {
	cmake_src_install
	docompress -x /usr/share/man
}
