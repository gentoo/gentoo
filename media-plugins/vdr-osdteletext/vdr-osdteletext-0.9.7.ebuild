# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

VERSION="2161" # every bump, new version

DESCRIPTION="VDR Plugin: Osd-Teletext displays the teletext on the OSD"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-osdteletext"
SRC_URI="https://projects.vdr-developer.org/attachments/download/${VERSION}/${P}.tgz"

LICENSE="GPL-2+ public-domain" #teletext2.ttf, not copyrightable
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"

VDR_RCADDON_FILE="${FILESDIR}/rc-addon-v3.sh"
VDR_CONFD_FILE="${FILESDIR}/confd-v2"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*"

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/sudoers.d
	insopts -m440
	newins "${FILESDIR}/vdr-osdteletext.sudo" vdr-osdteletext

	local vdr_user_home="/var/vdr"
	insinto "${vdr_user_home}/.local/share/fonts/"
	insopts -m444
	doins teletext2.ttf
	fowners -R vdr:vdr "${vdr_user_home}/.local"
}

pkg_postinst() {
	elog "This ebuild has installed a special teletext font"
	elog "named \"teletext2\""
	elog "You may go to the plugin's setup menu and select"
	elog "the font."
}
