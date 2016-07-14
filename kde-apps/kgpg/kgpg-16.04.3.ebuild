# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
KDE_SELINUX_MODULE="gpg"
inherit kde4-base

DESCRIPTION="Frontend for GnuPG, a powerful encryption utility by KDE"
HOMEPAGE="https://www.kde.org/applications/utilities/kgpg
https://utils.kde.org/projects/kgpg"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs)
"
RDEPEND="${DEPEND}
	app-crypt/gnupg
"

pkg_postinst() {
	kde4-base_pkg_postinst

	if ! has_version 'app-crypt/dirmngr' && ! has_version '>=app-crypt/gnupg-2.1'; then
		elog "For improved key search functionality, install app-crypt/dirmngr."
	fi
}
