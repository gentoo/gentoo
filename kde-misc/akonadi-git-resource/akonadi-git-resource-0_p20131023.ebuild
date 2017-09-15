# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

SQL_REQUIRED="always"
inherit kde4-base

DESCRIPTION="Git commit integration in Akonadi"
HOMEPAGE="https://projects.kde.org/projects/playground/pim/akonadi-git-resource"
LICENSE="GPL-2"

SRC_URI="https://dev.gentoo.org/~johu/distfiles/${P}.tar.xz"

SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs)
	>=dev-libs/libgit2-0.17
"
