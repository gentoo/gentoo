# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: support output on Graphical LCD"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-graphlcd/"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-graphlcd/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-graphlcd-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="acct-user/vdr[graphlcd]"
DEPEND="app-misc/graphlcd-base
	media-fonts/corefonts
	media-video/vdr"
RDEPEND="${DEPEND}
	acct-user/vdr[graphlcd]"

PATCHES=( "${FILESDIR}/${PN}-1.0.1_no-font.patch" )

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -e "s:SKIP_INSTALL_DOC ?= 0:SKIP_INSTALL_DOC ?= 1:" -i Makefile || die
}

src_install() {
	vdr-plugin-2_src_install

	insopts -m0644 -ovdr -gvdr

	insinto /usr/share/vdr/${VDRPLUGIN}/logos
	doins -r ${VDRPLUGIN}/logos/*

	insinto /etc/vdr/plugins/${VDRPLUGIN}
	doins ${VDRPLUGIN}/channels.alias

	# do we need this sym link? need testing..
	dosym "../../fonts/corefonts" "/usr/share/vdr/graphlcd/fonts"

	dosym ${sysroot}/usr/share/fonts/corefonts ${sysroot}/etc/vdr/plugins/"${VDRPLUGIN}"/fonts
	dosym ${sysroot}/usr/share/vdr/"${VDRPLUGIN}"/logos ${sysroot}/etc/vdr/plugins/"${VDRPLUGIN}"/logos
	dosym ${sysroot}/etc/graphlcd.conf ${sysroot}/etc/vdr/plugins/"${VDRPLUGIN}"/graphlcd.conf

	# do we need this sym link? need testing..
#	dosym "logonames.alias.1.3" "/etc/vdr/plugins/${VDRPLUGIN}/logonames.alias"
}

pkg_preinst() {
	if [[ -e /etc/vdr/plugins/graphlcd/fonts ]] && [[ ! -L /etc/vdr/plugins/graphlcd/fonts ]] \
	|| [[ -e /etc/vdr/plugins/graphlcd/logos ]] && [[ ! -L /etc/vdr/plugins/graphlcd/logos ]] ; then
		elog "Remove wrong DIR in /etc/vdr/plugins/graphlcd from prior install"
		rm -R /etc/vdrplugins/graphlcd/{fonts,logos} || die
	fi
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	einfo "Add additional options in /etc/conf.d/vdr.graphlcd\n"

	einfo "Please copy or link one of the supplied fonts.conf.*"
	einfo "files in /etc/vdr/plugins/graphlcd/ to"
	einfo "/etc/vdr/plugins/graphlcd/fonts.conf"
}
