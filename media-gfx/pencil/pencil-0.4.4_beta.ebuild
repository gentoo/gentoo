# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils qt4-r2

MY_P=${P/_beta/b}

DESCRIPTION="A Qt4 based animation and drawing program"
HOMEPAGE="http://www.pencil-animation.org/"
SRC_URI="mirror://sourceforge/pencil-planner/${MY_P}-src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtgui:4
	dev-qt/qtopengl:4
	>=media-libs/ming-0.4.3"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_P}-source

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc461.patch
	sed -i s:SWFSprite:SWFMovieClip:g src/external/flash/flash.{cpp,h} || die
}

src_install() {
	# install target not yet provided
	#emake INSTALL_ROOT="${D}" install || die "emake install failed"
	newbin Pencil ${PN} || die "dobin failed"

	dodoc README TODO || die

	mv "${S}"/icons/icon.png "${S}"/icons/${PN}.png
	doicon "${S}"/icons/${PN}.png || die "doicon failed"
	make_desktop_entry ${PN} Pencil ${PN} Graphics
}
