# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="vdr-plugin-graphlcd"
MY_P="${MY_PN}-${PV}"

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: support output on Graphical LCD"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-graphlcd"
SRC_URI="https://projects.vdr-developer.org/git/${MY_PN}.git/snapshot/${MY_P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND=">=app-misc/graphlcd-base-${PV}
	media-fonts/corefonts
	media-video/vdr"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	vdr-plugin-2_pkg_setup

	if ! getent group lp | grep -q vdr; then
		einfo
		einfo "Add user 'vdr' to group 'lp' for full user access to parport device"
		elog
		elog "User vdr added to group lp"
		gpasswd -a vdr lp || die
	fi
	if ! getent group usb | grep -q vdr; then
		einfo
		einfo "Add user 'vdr' to group 'usb' for full user access to usb device"
		elog
		elog "User vdr added to group usb"
		gpasswd -a vdr usb || die
	fi
}

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i "s:/usr/local:/usr:" Makefile || die
	sed -i "s:i18n.c:i18n.h:g" Makefile || die
	sed -i "s:include \$(VDRDIR)/Make.global:-include \$(VDRDIR)/Make.global:" Makefile || die

	sed -i "s:SKIP_INSTALL_DOC ?= 0:SKIP_INSTALL_DOC ?= 1:" Makefile || die

	eapply "${FILESDIR}/${P}_no-font.patch"
}

src_install() {
	vdr-plugin-2_src_install

	insopts -m0644 -ovdr -gvdr

	insinto /usr/share/vdr/${VDRPLUGIN}/logos
	doins -r ${VDRPLUGIN}/logos/*

	insinto /etc/vdr/plugins/${VDRPLUGIN}
	doins ${VDRPLUGIN}/channels.alias

	# do we need this sym link? need testing..
	dosym "${EPREFIX}/usr/share/fonts/corefonts" "${EPREFIX}/usr/share/vdr/graphlcd/fonts"

	dosym "${EPREFIX}/usr/share/fonts/corefonts" "${EPREFIX}/etc/vdr/plugins/${VDRPLUGIN}/fonts"
	dosym "${EPREFIX}/usr/share/vdr/${VDRPLUGIN}/logos" "${EPREFIX}/etc/vdr/plugins/${VDRPLUGIN}/logos"
	dosym "${EPREFIX}/etc/graphlcd.conf" "${EPREFIX}/etc/vdr/plugins/${VDRPLUGIN}/graphlcd.conf"

	# do we need this sym link? need testing..
#	dosym "${EPREFIX}/etc/vdr/plugins/${VDRPLUGIN}/logonames.alias.1.3" "${EPREFIX}/etc/vdr/plugins/${VDRPLUGIN}/logonames.alias"
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
