# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kimtoy/kimtoy-1.8.ebuild,v 1.2 2014/10/31 16:04:42 kensington Exp $

EAPI=5

KDE_LINGUAS="cs da de es et ga ja it nds nl pl pt pt_BR sk sv uk zh_CN"
inherit kde4-base

DESCRIPTION="An input method frontend for KDE"
HOMEPAGE="http://kde-apps.org/content/show.php/KIMToy?content=140967"
SRC_URI="http://kde-apps.org/CONTENT/content-files/140967-${P}.tar.bz2"

SLOT="4"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2+"
IUSE=""

DEPEND="
	>=app-i18n/fcitx-4.0
	>=app-i18n/scim-1.4.9
	dev-libs/dbus-c++
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep plasma-workspace)
"

src_configure() {
	local mycmakeargs=(
		-DWITH_IBus=OFF
	)

	kde4-base_src_configure
}
