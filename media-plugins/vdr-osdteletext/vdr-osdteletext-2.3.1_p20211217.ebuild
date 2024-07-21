# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit user-info vdr-plugin-2

GITHASH="cae4629f84886015b0619af6fdb1084853b80f93"
DESCRIPTION="VDR Plugin: Osd-Teletext displays the teletext/videotext on the OSD"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-osdteletext/"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-osdteletext/archive/${GITHASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-osdteletext-${GITHASH}"

LICENSE="GPL-2+ public-domain" #teletext2.ttf, not copyrightable
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="acct-user/vdr"
DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="
	usr/lib/vdr/plugins/libvdr-.*
	usr/lib64/vdr/plugins/libvdr-.*"

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/sudoers.d
	insopts -m440
	newins "${FILESDIR}/vdr-osdteletext.sudo" vdr-osdteletext

	local vdr_user_home=$(egethome vdr)
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
