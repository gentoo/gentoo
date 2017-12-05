# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_LINGUAS="af ar be bg br ca ca@valencia cs cy da de el en_GB eo es et eu fa
fi fr ga gl he hi hne hr hu is it ja km ku lt lv mai mk ms nb nds ne nl nn oc
pa pl pt pt_BR ro ru se sk sl sv ta tg th tr uk vi xh zh_CN zh_HK zh_TW"
KDE_DOC_DIRS="doc doc-translations/%lingua_${PN}"
KDE_HANDBOOK="optional"
inherit kde4-base

MY_P=${P}-kde4.4.0

DESCRIPTION="Tool for editing color palettes"
HOMEPAGE="https://userbase.kde.org/KColorEdit"
SRC_URI="mirror://kde/stable/4.4.0/src/extragear/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}/${P}-underlinking.patch" )
