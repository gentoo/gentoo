# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kdepim"
QT3SUPPORT_REQUIRED="true"
SQL_REQUIRED="always"
inherit kde4-meta

DESCRIPTION="Application to create, edit and update blog content"
HOMEPAGE="https://launchpad.net/~pali/+archive/ubuntu/kdepim-noakonadi"

KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs)
"
RDEPEND="${DEPEND}"
