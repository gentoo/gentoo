# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

MY_P="${PN}-${PV%_p*}"

DESCRIPTION="VDR plugin: lets VDR listen to WAP requests on WML enabled browsers"
HOMEPAGE="http://www.heiligenmann.de/"
SRC_URI="http://www.heiligenmann.de/vdr/download/${MY_P}.tgz
		http://www.heiligenmann.de/vdr/download/${MY_P#vdr-}-patch1.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.3.44"

PATCHES=("${FILESDIR}/${MY_P}_gcc-4.1.x.diff"
	"${FILESDIR}/${MY_P}-gentoo.diff"
	"${WORKDIR}/${MY_P#vdr-}-patch1.diff")

S="${WORKDIR}/${MY_P#vdr-}"

src_prepare() {
	cp "${FILESDIR}/wapd.mk" "${S}/Makefile"

	vdr-plugin-2_src_prepare

	sed -e "s:RegisterI18n://RegisterI18n:" -i wapd.c
	vdr_remove_i18n_include server.c wapd.c
}

src_install() {
	vdr-plugin-2_src_install

	dobin "${S}/wappasswd"

	insinto /etc/vdr/plugins/wapd
	doins "${FILESDIR}"/{waphosts,wapaccess}
}
