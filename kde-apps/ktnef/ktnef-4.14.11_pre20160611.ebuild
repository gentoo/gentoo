# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="Viewer for TNEF attachments"

KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
LICENSE="LGPL-2.1"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs)
	kde-apps/akonadi:4
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	akonadi/
"
