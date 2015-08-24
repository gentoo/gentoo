# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="An extensible cross-desktop storage service for PIM data and meta data"
HOMEPAGE="https://pim.kde.org/akonadi"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	>=app-office/akonadi-server-1.3.1[soprano(+)]
	$(add_kdebase_dep kdelibs 'nepomuk' 4.13.1)
	$(add_kdebase_dep kdepimlibs '' 4.13.1)
	$(add_kdebase_dep libkdepim)
	!kde-base/akonadiconsole
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep kdepim-runtime)
"

KMEXTRA="
	akonadiconsole/
"

src_configure() {
	mycmakeargs=(
		# Set the dbus dirs, otherwise it searches in KDEDIR
		-DAKONADI_DBUS_INTERFACES_INSTALL_DIR="${EPREFIX}/usr/share/dbus-1/interfaces"
		-DAKONADI_DBUS_SERVICES_INSTALL_DIR="${EPREFIX}/usr/share/dbus-1/services"
	)

	kde4-meta_src_configure
}
