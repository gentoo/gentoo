# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE hexeditor"
HOMEPAGE="https://www.kde.org/applications/utilities/okteta
https://utils.kde.org/projects/okteta"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	app-crypt/qca:2[qt4(+)]
"
RDEPEND="${DEPEND}"
