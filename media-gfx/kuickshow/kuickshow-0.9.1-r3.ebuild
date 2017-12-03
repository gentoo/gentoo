# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_DOC_DIRS="doc doc-translations/%lingua_${PN}"
inherit kde4-base

MY_P=${P}-kde4.4.0

DESCRIPTION="KDE program to view images"
HOMEPAGE="https://userbase.kde.org/KuickShow"
SRC_URI="mirror://kde/Attic/4.4.0/src/extragear/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug +handbook"

DEPEND="media-libs/imlib"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS BUGS ChangeLog README TODO )

PATCHES=(
	"${FILESDIR}/${P}-gcc6-compile-fix.patch"
)

S=${WORKDIR}/${MY_P}
