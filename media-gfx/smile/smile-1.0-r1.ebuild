# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

LANGS="de en it pl pt ru"

inherit eutils qmake-utils

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
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick-compat] )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/fix_installation.patch"
	"${FILESDIR}/fix_docs-0.9.10.patch"
)

S="${WORKDIR}/${PN}"

src_prepare() {
	default

	eqmake4
	# fix version string on applied patch
	sed -i "s/${PN}-0.9.10/${P}/" "${S}"/helpfrm.cpp \
		|| die "failed to fix docs path"
}

src_install() {
	dobin smile
	doicon Interface/Theme/${PN}.png
	make_desktop_entry smile Smile smile "Qt;AudioVideo;Video"

	dodoc BIB_ManSlide/Help/doc_en.html
	dodoc BIB_ManSlide/Help/doc_fr.html
	dodoc -r BIB_ManSlide/Help/images
	dodoc -r BIB_ManSlide/Help/images_en
	dodoc -r BIB_ManSlide/Help/images_fr

	#translations
	insinto /usr/share/${PN}/translations/
	local lang x
	for lang in ${L10N}; do
		for x in ${LANGS}; do
			if [[ ${lang} == ${x} ]]; then
				doins ${PN}_${x}.qm || die "failed to install ${x} translation"
			fi
		done
	done
}
