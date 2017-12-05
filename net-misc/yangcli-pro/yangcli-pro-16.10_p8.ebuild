# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit unpacker

RESTRICT="bindist mirror strip"
MY_PV=${PV/_p/-}
MY_P=${PN}-${MY_PV}
S=${WORKDIR}

DESCRIPTION="Network manager client that lets you test and manage NETCONF servers"
HOMEPAGE="https://www.yumaworks.com/yangcli-pro/"
SRC_URI="amd64? ( https://www.yumaworks.com/pub/${PN}/${MY_PV}/deb8/${MY_P}.deb8.amd64.deb )"

LICENSE="yangcli-pro"
SLOT="0"
KEYWORDS="~amd64 -*"
IUSE=""

RDEPEND="net-libs/libssh2
	 sys-libs/ncurses:5/5[tinfo]"

src_install() {
	dodoc usr/share/doc/yangcli-pro/changelog.gz
	dodoc usr/share/doc/yumapro/*.pdf
	dodoc usr/share/doc/yumapro/README
	dobin usr/bin/yangcli-pro
	dolib usr/lib/libyumapro_{ncx,mgr,ycli}.so{,.16.10}
	doman usr/share/man/man1/yangcli-pro.1.gz
	local my_module
	for my_module in ietf/{RFC,DRAFT} netconfcentral yumaworks ; do
		insinto /usr/share/yumapro/modules/${my_module}
		doins usr/share/yumapro/modules/${my_module}/*.yang
	done
	insinto /etc/yumapro
	doins etc/yumapro/yangcli-pro-sample.conf
}
