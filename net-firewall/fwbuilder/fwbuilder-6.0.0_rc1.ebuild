# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A firewall management GUI for iptables, PF, Cisco routers and more"
HOMEPAGE="https://github.com/fwbuilder/fwbuilder"
SRC_URI="https://github.com/fwbuilder/fwbuilder/archive/refs/tags/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P/_/-}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libxml2
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

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	docompress -x /usr/share/man
}
