# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="Personal alarm message, command and email scheduler by KDE"
HOMEPAGE+=" https://userbase.kde.org/KAlarm"

KEYWORDS="amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep kdepim-common-libs)
	$(add_kdeapps_dep kdepimlibs)
	$(add_kdeapps_dep ktimezoned)
	media-libs/phonon[qt4]
	x11-libs/libX11
"
DEPEND="${RDEPEND}"

KMEXTRACTONLY="
	kmail/
"
