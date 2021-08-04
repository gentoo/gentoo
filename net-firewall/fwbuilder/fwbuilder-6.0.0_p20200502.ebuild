# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake vcs-snapshot

MY_COMMIT=a5e14a966447c63bcf7b52a0202149e76bd5ed4a
DESCRIPTION="A firewall management GUI for iptables, PF, Cisco routers and more"
HOMEPAGE="https://github.com/fwbuilder/fwbuilder"
SRC_URI="https://github.com/fwbuilder/fwbuilder/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/openssl
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	net-analyzer/net-snmp
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fix_version.patch
	"${FILESDIR}"/${PN}-6.0.0_p20200502-drop-Werror.patch
)

src_install() {
	cmake_src_install
	docompress -x /usr/share/man
}
