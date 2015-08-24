# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE calculator"
HOMEPAGE="https://www.kde.org/applications/utilities/kcalc
https://utils.kde.org/projects/kcalc"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	dev-libs/gmp
"
RDEPEND="${DEPEND}"
