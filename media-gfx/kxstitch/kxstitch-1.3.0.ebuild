# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_DOC_DIRS="doc-translations/%lingua_${PN}"
KDE_HANDBOOK="optional"
KDE_LINGUAS="bs ca ca@valencia cs da de en_GB es et fr hu it ja lt nl pl pt pt_BR sk sv tr uk"
inherit kde4-base

DESCRIPTION="Program to create cross stitch patterns"
HOMEPAGE="https://userbase.kde.org/KXStitch"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="4"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="
	media-gfx/imagemagick[cxx]
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"
