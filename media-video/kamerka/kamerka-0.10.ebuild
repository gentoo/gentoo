# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="cs de es nl pl pt ru sr sr@ijekavian sr@ijekavianlatin sr@Latn uk zh_CN zh_TW"
inherit kde4-base

SRC_URI="http://dosowisko.net/${PN}/downloads/${P}.tar.gz"
DESCRIPTION="Simple photo taking application with fancy animated interface"
HOMEPAGE="http://dos1.github.io/kamerka/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-qt/qtdeclarative:4
	media-libs/libv4l
	media-libs/phonon[qt4]
	media-libs/qimageblitz
"
DEPEND="${RDEPEND}"
