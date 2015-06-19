# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gpe-base/gpe/gpe-2.8.ebuild,v 1.5 2010/03/06 18:22:37 miknix Exp $

EAPI="2"

DESCRIPTION="Meta package for the GPE Palmtop Environment"
HOMEPAGE="http://linuxtogo.org/gowiki/GPERoadmap"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~arm ~amd64 ~x86"
IUSE="games"

RDEPEND="
>=x11-wm/matchbox-window-manager-1.2
>=x11-wm/matchbox-panel-0.9.3
>=x11-wm/matchbox-desktop-0.9.1

>=gpe-base/gpe-dm-0.51
>=gpe-base/gpe-login-0.90
>=gpe-base/gpe-icons-0.25
>=gpe-base/gpe-contacts-0.47
>=gpe-base/gpe-calculator-0.2
>=gpe-base/gpe-gallery-0.97

>=gpe-utils/gpe-clock-0.25
>=gpe-utils/gpe-edit-0.40
>=gpe-utils/gpe-ownerinfo-0.28
>=gpe-utils/gpe-taskmanager-0.20
>=gpe-utils/gpe-what-0.5
>=gpe-utils/gpe-filemanager-0.30
>=gpe-utils/gpe-plucker-0.4

games? (
	>=games-misc/gpe-julia-0.0.6
	>=games-puzzle/gpe-lights-0.13
)"

pkg_postinst() {
	einfo "Please have a look to the GPE configuration guide:"
	einfo "http://dev.gentoo.org/~miknix/gpe-config.html"
}
