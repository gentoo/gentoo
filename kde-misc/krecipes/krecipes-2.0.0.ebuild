# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/krecipes/krecipes-2.0.0.ebuild,v 1.1 2015/02/21 12:22:55 kensington Exp $

EAPI=5

KDE_LINGUAS="bg bs ca ca@valencia cs da de el en_GB eo es et fr ga gl hi hne hr hu
is it ja kk lt mai mr nb nds nl nn pl pt pt_BR ro sk sl sv tr uk zh_TW"
KDE_HANDBOOK="optional"
VIRTUALX_REQUIRED="test"
inherit kde4-base

DESCRIPTION="A KDE4 recipe application"
HOMEPAGE="http://krecipes.sourceforge.net/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

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

DOCS=( AUTHORS BUGS README TODO ChangeLog )
