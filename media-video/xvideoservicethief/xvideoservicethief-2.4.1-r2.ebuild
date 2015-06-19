# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/xvideoservicethief/xvideoservicethief-2.4.1-r2.ebuild,v 1.5 2013/03/02 22:44:32 hwoarang Exp $

EAPI=2

LANGS="br ca cs da de es fr gl hu it ja ko nl pl ro ru sv"

inherit eutils qt4-r2 versionator

MY_PV=$(replace_all_version_separators '_')
MY_P="xVST_${MY_PV}_src"

DESCRIPTION="Download (and convert) videos from various Web Video Services"
HOMEPAGE="http://xviservicethief.sourceforge.net/"
SRC_URI="mirror://sourceforge/xviservicethief/${MY_P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug doc"

DEPEND="app-arch/unzip
	>=dev-qt/qtgui-4.5.3:4
	>=dev-qt/qtwebkit-4.5.3:4
	doc? ( app-doc/doxygen )"
RDEPEND=">=dev-qt/qtgui-4.5.3:4
	virtual/ffmpeg
	media-video/flvstreamer"

RES_NAME="xVST"

S="${WORKDIR}"

src_prepare() {
	# fix translations
	mv "${S}"/resources/translations/${RES_NAME}_cz.ts \
		"${S}"/resources/translations/${RES_NAME}_cs.ts ||die
	mv "${S}"/resources/translations/${RES_NAME}_jp.ts	\
		"${S}"/resources/translations/${RES_NAME}_ja.ts || die
	mv "${S}"/resources/translations/${RES_NAME}_du.ts	\
		"${S}"/resources/translations/${RES_NAME}_nl.ts || die
	mv "${S}"/resources/translations/${RES_NAME}_kr.ts	\
		"${S}"/resources/translations/${RES_NAME}_ko.ts || die
	# fix plugins, language path
	sed -i -e "s/getApplicationPath()\ +\ \"/\"\/usr\/share\/${PN}/g" \
		"${S}"/src/options.cpp || die "failed to fix paths"
	epatch "${FILESDIR}"/${P}-youtube-api.patch
	# bug 427066
	epatch "${FILESDIR}"/${P}-gcc47.patch
}

src_compile() {
	local lang=
	emake || die "emake failed"
	for lang in "${S}"/resources/translations/*.ts; do
		lrelease ${lang}
	done
}

src_install() {
	dobin bin/xvst || die "dobin failed"
	local dest=/usr/share/${PN}/plugins
	dodir ${dest}
	find resources/services -name '*.js' -exec cp -dpR {} "${D}"${dest} \;
	newicon resources/images/InformationLogo.png xvst.png
	make_desktop_entry /usr/bin/xvst xVideoServiceThief xvst 'Qt;AudioVideo;Video'
	if use doc; then
		cd "${S}/documentation/source"
		sed -i "/OUTPUT_DIRECTORY/s:G\:.*:docs:" Doxyfile
		doxygen Doxyfile
		dohtml -r docs/html/* || die "dohtml failed"
	fi

	#install translations
	insinto /usr/share/${PN}/languages/
	local lang= tlang=
	for lang in ${LINGUAS}; do
		for tlang in ${LANGS}; do
			[[ ${lang} == ${tlang} ]] && doins "${S}"/resources/translations/xVST_${tlang}.qm
		done
	done
}
