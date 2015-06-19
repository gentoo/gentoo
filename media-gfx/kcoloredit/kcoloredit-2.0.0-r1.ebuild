# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/kcoloredit/kcoloredit-2.0.0-r1.ebuild,v 1.2 2014/04/26 12:34:34 johu Exp $

EAPI=5

KDE_LINGUAS="af ar be bg br ca ca@valencia cs cy da de el en_GB eo es et eu fa
fi fr ga gl he hi hne hr hu is it ja km ku lt lv mai mk ms nb nds ne nl nn oc
pa pl pt pt_BR ro ru se sk sl sv ta tg th tr uk vi xh zh_CN zh_HK zh_TW"
KDE_DOC_DIRS="doc doc-translations/%lingua_${PN}"
KDE_HANDBOOK="optional"
inherit kde4-base

KDE_VERSION=4.4.0
MY_P=${P}-kde${KDE_VERSION}

DESCRIPTION="Tool for editing color palettes"
HOMEPAGE="http://www.kde.org/"
SRC_URI="mirror://kde/stable/${KDE_VERSION}/src/extragear/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}/${P}-underlinking.patch" )
