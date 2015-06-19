# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kio_gopher/kio_gopher-0.1.4.ebuild,v 1.4 2015/06/04 18:57:33 kensington Exp $

EAPI=5

KDE_LINGUAS="ar bg br ca ca@valencia cs cy da de el en_GB eo es et fi fr ga gl
hr hu is it ja ka km lt lv ms nb nds nl nn pa pl pt pt_BR ro ru rw sk sv ta tr
ug uk zh_CN zh_TW"
KDE_HANDBOOK="optional"
KDE_DOC_DIRS="doc doc-translations/%lingua_kioslave"
inherit kde4-base

MY_P=${PN/_/-}-${PV}

DESCRIPTION="Gopher Kioslave for Konqueror"
HOMEPAGE="http://userbase.kde.org/Kio_gopher"
SRC_URI="mirror://kde/stable/extragear/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep konqueror)
"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

DOCS=( BUGS ChangeLog FAQ README )
