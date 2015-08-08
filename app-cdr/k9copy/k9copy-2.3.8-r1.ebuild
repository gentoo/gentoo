# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_DOC_DIRS="doc"
KDE_HANDBOOK="optional"
KDE_LINGUAS="ca cs da de el es es_AR fr it ja nl pl pt_BR ru sr sr@Latn tr uk zh_TW"
KDE_LINGUAS_LIVE_OVERRIDE="true"
MY_P=${P}-Source
KDE_SCM="svn"
inherit kde4-base

ESVN_REPO_URI="https://k9copy.svn.sourceforge.net/svnroot/k9copy/kde4"
ESVN_PROJECT="k9copy"
DESCRIPTION="k9copy is a DVD backup utility which allows the copy of one or more titles from a DVD9 to a DVD5"
HOMEPAGE="http://k9copy.sourceforge.net/"
[[ ${PV} != *9999* ]] && SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug mplayer"

DEPEND="
	media-libs/libdvdread
	media-libs/libmpeg2
	media-libs/xine-lib
	media-video/ffmpeg
"
RDEPEND="${DEPEND}
	media-video/dvdauthor
	mplayer? ( media-video/mplayer )
"
DOCS=( README )

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${P}-ffmpeg-0.11.patch"
	"${FILESDIR}/${P}-includepaths.patch"
	"${FILESDIR}/${P}-ffmpeg-2.1.patch"
)

pkg_postinst() {
	kde4-base_pkg_postinst
	has_version '>=app-cdr/k3b-1.50' || elog "If you want K3b burning support in ${P}, please install app-cdr/k3b separately."
}
