# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/krecipes/krecipes-2.0_beta2-r1.ebuild,v 1.2 2014/03/21 18:13:19 johu Exp $

EAPI=5

KDE_LINGUAS="bg ca ca@valencia cs da de el en_GB eo es et fr ga gl hi hne hr hu
is it ja lt mai nb nds nl nn pl pt pt_BR ro sk sv tr uk zh_TW"
KDE_DOC_DIRS="doc doc-translations/%lingua_${PN}"
KDE_HANDBOOK="optional"
VIRTUALX_REQUIRED="test"
inherit kde4-base

DESCRIPTION="A KDE4 recipe application"
HOMEPAGE="http://krecipes.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/_/-}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="4"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

DEPEND="
	dev-db/sqlite:3
	dev-libs/libxml2
	dev-libs/libxslt
	media-libs/qimageblitz
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P/_/-}

DOCS=( AUTHORS BUGS README TODO ChangeLog )

PATCHES=( "${FILESDIR}/krecipes-2.0_beta2-remove-mx2test.patch" )
