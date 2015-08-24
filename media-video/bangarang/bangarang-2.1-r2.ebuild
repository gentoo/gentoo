# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="cs da de el es fi fr hu it lt nl pl pt pt_BR ru uk zh_CN"
KDE_SCM="git"
KDE_MINIMAL="4.13.1"
inherit kde4-base

DESCRIPTION="Media player for KDE utilizing Nepomuk for tagging"
HOMEPAGE="http://bangarangkde.wordpress.com"
[[ ${PV} == 9999 ]] || SRC_URI="https://bangarangissuetracking.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="amd64 x86"
SLOT="4"
IUSE="debug"

RDEPEND="
	dev-libs/soprano
	$(add_kdebase_dep kdelibs 'nepomuk')
	$(add_kdeapps_dep nepomuk)
	$(add_kdeapps_dep audiocd-kio)
	media-libs/taglib
	media-libs/phonon[qt4]
	dev-qt/qtscript:4
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

PATCHES=( "${FILESDIR}/${P}-gcc-4.7.patch" )

S=${WORKDIR}/bangarang-bangarang
