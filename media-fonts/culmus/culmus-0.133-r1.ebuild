# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

# Maintainer: also check culmus.conf file in ${P}.tar.gz

MY_A_P=AncientSemiticFonts-0.06-1
# The Type 1 fonts are just a stripped version of TrueType fonts and they are
# not updated unless there is a meaningful change and we need them for
# culmus-latex, see bug #350657
TYPE1_PV=0.105

DESCRIPTION="Hebrew Type1 fonts"
HOMEPAGE="http://culmus.sourceforge.net/"

FANCY_FONTS="journal hillel anka comix gan ozrad ktav-yad dorian gladia horev"
FANCY_YG_FONTS="ShmuelCLM MakabiYG"
TAAMEY_FONTS="TaameyDavidCLM TaameyFrankCLM KeterAramTsova KeterYG"

SRC_URI="mirror://sourceforge/culmus/${P}.tar.gz
	mirror://sourceforge/culmus/${PN}-type1-${TYPE1_PV}.tar.gz
	fontforge? ( mirror://sourceforge/culmus/${PN}-src-${PV}.tar.gz )
	ancient? ( !fontforge? ( mirror://sourceforge/culmus/${MY_A_P}.TTF.tgz )
		fontforge? ( mirror://sourceforge/culmus/${MY_A_P}.tgz ) )"
SRC_URI+=" fancy? ( $(printf "http://culmus.sourceforge.net/fancy/%s.tar.gz " ${FANCY_FONTS}) )"
SRC_URI+=" fancy? ( $(printf "http://culmus.sourceforge.net/fancy-yg/%s.zip " ${FANCY_YG_FONTS}) )"
SRC_URI+=" taamey? ( $(printf "http://culmus.sourceforge.net/taamim/%s.zip " ${TAAMEY_FONTS}) )"

# Some fonts are available in otf format too. Do we need them?
#	http://culmus.sourceforge.net/fancy/anka-otf.zip
#	http://culmus.sourceforge.net/fancy/hillel-otf.zip
#	http://culmus.sourceforge.net/fancy/journal-otf.zip

LICENSE="|| ( GPL-2 LICENSE-BITSTREAM ) ancient? ( MIT ) fancy? ( GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 sparc x86"
IUSE="ancient fancy fontforge taamey"

FONT_CONF=( "${T}"/65-culmus.conf )

RDEPEND="!media-fonts/culmus-ancient"
# >=x11-apps/mkfontscale-1.0.9-r1 as Heavy weight support is required
BDEPEND="
	app-arch/unzip
	>=x11-apps/mkfontscale-1.0.9-r1
	fontforge? ( media-gfx/fontforge )
"

S="${WORKDIR}"
# Put all fonts, generated or not here
FONT_S="${S}/FONTS"

PATCHES=( "${FILESDIR}/${P}-fontconfig-test.patch" ) # bug 695708

src_unpack() {
	unpack ${P}.tar.gz # For type1 fonts...
	unpack ${PN}-type1-${TYPE1_PV}.tar.gz
	use fontforge && unpack ${PN}-src-${PV}.tar.gz

	use ancient && unpack ${MY_A_P}$(usex fontforge '' .TTF).tgz

	if use fancy; then
		unpack $(printf "%s.tar.gz " ${FANCY_FONTS})
		unpack $(printf "%s.zip " ${FANCY_YG_FONTS})
		mv TTF/* . || die
	fi

	if use taamey; then
		for font in ${TAAMEY_FONTS}; do
			mkdir ${font} || die
			pushd ${font} > /dev/null || die
				unpack ${font}.zip
			popd > /dev/null || die
		done
	fi
}

src_prepare() {
	default
	cp "${P}"/culmus.conf "${T}"/65-culmus.conf || die
}

src_compile() {
	mkdir -p "${FONT_S}" || die
	if use fontforge; then
		pushd ${P} > /dev/null || die
			mv *.afm *.pfa "${FONT_S}" || die
			rm *.ttf || die
		popd > /dev/null || die

		pushd ${PN}-type1-${TYPE1_PV} > /dev/null || die
			mv *.afm *.pfa "${FONT_S}" || die
		popd > /dev/null || die

		pushd ${PN}-src-${PV} > /dev/null || die
			for f in *.sfd; do
				"${WORKDIR}"/${PN}-src-${PV}/GenerateTTF.pe ${f} "${FONT_S}" || die
			done
		popd > /dev/null || die

		if use ancient; then
			pushd ${MY_A_P}/src > /dev/null || die
				export FONTFORGE_LANGUAGE=ff
				make clean || die
				make all || die "Failed to build fonts"
				mv *.ttf "${FONT_S}" || die
			popd > /dev/null || die
		fi

		if use taamey; then
			for font in ${TAAMEY_FONTS}; do
				rm -rf ${font}/TTF || die
				pushd ${font}/SFD > /dev/null || die
					for f in *.sfd; do
						"${WORKDIR}"/${PN}-src-${PV}/GenerateTTF.pe ${f} "${FONT_S}" || die
					done
				popd > /dev/null || die
			done
		fi
	else
		pushd ${P} > /dev/null || die
			mv *.afm *.pfa *.ttf "${FONT_S}" || die
		popd >/dev/null || die

		pushd ${PN}-type1-${TYPE1_PV} > /dev/null || die
			mv *.afm *.pfa "${FONT_S}" || die
		popd > /dev/null || die

		if use ancient; then
			pushd ${MY_A_P}$(usex fontforge '' .TTF)/fonts > /dev/null || die
				mv *.ttf "${FONT_S}" || die
			popd > /dev/null || die
		fi

		if use taamey; then
			for font in ${TAAMEY_FONTS}; do
				pushd ${font}/TTF > /dev/null || die
					mv *.ttf "${FONT_S}" || die
				popd > /dev/null || die
			done
		fi
	fi

	if use fancy; then
		mv *.afm *.pfa *.ttf "${FONT_S}" || die
	fi
}

src_install() {
	einstalldocs

	FONT_SUFFIX="pfa afm $((use fancy || use taamey) && echo ttf)" \
		font_src_install

	rm -rf "${FONT_S}" || die
	find "${WORKDIR}" -name '*.ttf' -o -name '*.pfa' -o -name '*.pfm' |
		while read font; do
			ewarn "QA: missed font file: ${font}"
		done

	pushd ${PN}$(usex fontforge -src '')-${PV} > /dev/null || die
		dodoc CHANGES
	popd > /dev/null || die

	if use ancient; then
		pushd "${WORKDIR}/${MY_A_P}$(usex fontforge '' .TTF)/" > /dev/null || die
		newdoc CHANGES{,.ancient} || die
		newdoc README{,.ancient} || die
		popd > /dev/null || die
	fi

	if use taamey; then
		for font in ${TAAMEY_FONTS}; do
			pushd ${font} > /dev/null || die
				docinto ${font}
				[[ -f ChangeLog ]] && { newdoc ChangeLog{,.${font}} || die; }
				newdoc README{,.${font}} || die
				dodoc -r Samples
			popd > /dev/null || die
		done
	fi
}
