# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake

if [[ ${PV} == 9999* ]]
then
	EGIT_REPO_URI="https://github.com/fwbuilder/fwbuilder"
	inherit git-r3
	# remove hardcoded version string
	PATCHES=( "${FILESDIR}/${P}-remove_hardcoded_version.patch" )
else
	MY_PV=$(ver_rs 3 '-')
	S="${WORKDIR}/${PN}-$(ver_rs 3 '-')"
	SRC_URI="https://github.com/fwbuilder/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	RESTRICT="mirror"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

DESCRIPTION="A firewall management GUI for iptables, PF, Cisco routers and more"
HOMEPAGE="https://github.com/fwbuilder/fwbuilder"

LICENSE="GPL-2+"
SLOT="0"

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

src_install() {
	cmake_src_install
	docompress -x /usr/share/man
}
