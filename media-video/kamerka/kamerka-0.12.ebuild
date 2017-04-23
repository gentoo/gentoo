# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DECLARATIVE_REQUIRED="always"
KDE_LINGUAS="cs de es nl pl pt ru sr sr@ijekavian sr@ijekavianlatin sr@Latn uk zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="Simple photo taking application with fancy animated interface"
HOMEPAGE="http://dos1.github.io/kamerka/ https://github.com/dos1/kamerka"
SRC_URI="https://github.com/dos1/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libv4l
	media-libs/phonon[qt4]
	media-libs/qimageblitz
"
DEPEND="${RDEPEND}"
