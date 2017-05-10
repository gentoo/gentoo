# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="Note taking utility by KDE"
HOMEPAGE="https://www.kde.org/applications/utilities/kjots/"

KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepim-common-libs)
	$(add_kdeapps_dep kdepimlibs)
	dev-libs/grantlee:0
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	akonadi_next/
	noteshared/
"
