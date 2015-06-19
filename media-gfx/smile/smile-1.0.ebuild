# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/smile/smile-1.0.ebuild,v 1.7 2013/03/02 21:40:44 hwoarang Exp $

EAPI="2"
LANGS="de en it pl pt ru"

inherit eutils qt4-r2

DESCRIPTION="Slideshow Maker In Linux Environement"
HOMEPAGE="http://smile.tuxfamily.org/"
SRC_URI="http://download.tuxfamily.org/smiletool/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="media-sound/sox
	media-video/mplayer
	dev-qt/qtgui:4[debug?]
	dev-qt/qtopengl:4[debug?]
	dev-qt/qtwebkit:4[debug?]
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/fix_installation.patch"
	"${FILESDIR}/fix_docs-0.9.10.patch"
)

S="${WORKDIR}/${PN}"

src_prepare() {
	qt4-r2_src_prepare
	# fix version string on applied patch
	sed -i "s/${PN}-0.9.10/${P}/" "${S}"/helpfrm.cpp \
		|| die "failed to fix docs path"
}

src_install() {
	dobin smile || die "dobin failed"
	doicon Interface/Theme/${PN}.png || die "doicon failed"
	make_desktop_entry smile Smile smile "Qt;AudioVideo;Video"

	dodoc BIB_ManSlide/Help/doc_en.html
	dodoc BIB_ManSlide/Help/doc_fr.html
	insinto /usr/share/doc/${PF}/
	doins -r BIB_ManSlide/Help/images
	doins -r BIB_ManSlide/Help/images_en
	doins -r BIB_ManSlide/Help/images_fr
	#translations
	insinto /usr/share/${PN}/translations/
	for lang in ${LINGUAS};do
		for x in ${LANGS};do
			if [[ ${lang} == ${x} ]];then
				doins ${PN}_${x}.qm || die "failed to install ${x} translation"
			fi
		done
	done
}
