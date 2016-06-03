# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_LINGUAS="ar ast be bg ca ca@valencia cs da de el en_GB eo es et fi fr ga gl
hr hu it ja km ko ku lt mai nb nds nl nn pa pl pt pt_BR ro ru se sk
sr@ijekavian sr@ijekavianlatin sr@latin sv th tr uk zh_CN zh_TW"
KDE_SCM="git"
inherit kde4-base

DESCRIPTION="Media player with digital TV support by KDE"
HOMEPAGE="https://kaffeine.kde.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 FDL-1.2"
SLOT="4"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

DEPEND="
	x11-libs/libXScrnSaver
	dev-qt/qtsql:4[sqlite]
	>=media-video/vlc-1.2[X]
	x11-libs/libXScrnSaver
"
RDEPEND="${DEPEND}"

DOCS=( Changelog NOTES )

PATCHES=( "${FILESDIR}/${P}-cmake34.patch" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_DEBUG_MODULE=$(usex debug)
	)

	kde4-base_src_configure
}
