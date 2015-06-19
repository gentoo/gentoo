# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/networkmanagement/networkmanagement-0.9.0.12.ebuild,v 1.3 2015/03/13 09:26:51 ago Exp $

EAPI=5

KDE_LINGUAS="ar bs ca ca@valencia cs da de el es et fa fi fr ga gl hu ia it
ja kk km ko lt mr nb nds nl nn pl pt pt_BR ro ru se sk sl sr sr@ijekavian
sr@ijekavianlatin sr@Latn sv tr uk zh_CN zh_TW"
KDE_SCM="git"
KDE_MINIMAL="4.11"
inherit kde4-base

DESCRIPTION="KDE frontend for NetworkManager"
HOMEPAGE="https://projects.kde.org/projects/extragear/base/networkmanagement"
[[ ${PV} = 9999* ]] || SRC_URI="mirror://kde/unstable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="amd64 x86"
SLOT="4"
IUSE="debug openconnect"

DEPEND="
	net-misc/mobile-broadband-provider-info
	>=net-misc/networkmanager-0.9.6
	openconnect? (
		net-misc/networkmanager-openconnect
		net-misc/openconnect:=
	)
"
RDEPEND="${DEPEND}
	!kde-base/solid
	!kde-misc/plasma-nm
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with openconnect)
	)
	kde4-base_src_configure
}
