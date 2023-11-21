# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit user-info vdr-plugin-2

DESCRIPTION="VDR plugin: Show rdf Newsticker on TV"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://vdr.websitec.de/download/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"

BDEPEND="acct-user/vdr"
DEPEND="${BDEPEND}
	>=media-video/vdr-1.2.6
	net-misc/wget"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-gcc4.diff" )
QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*"

src_install() {
	vdr-plugin-2_src_install

	local vdr_user_home=$(egethome vdr)
	keepdir "${vdr_user_home}/newsticker/"
	fowners -R vdr:vdr "${vdr_user_home}//newsticker/"
}
