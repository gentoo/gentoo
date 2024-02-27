# Copyright 1999-2023 Gentoo Authors
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
HOMEPAGE="https://culmus.sourceforge.io/"

FANCY_FONTS="journal hillel anka comix gan ozrad ktav-yad dorian gladia horev"
FANCY_YG_FONTS="ShmuelCLM MakabiYG"
TAAMEY_FONTS="TaameyDavidCLM TaameyFrankCLM KeterAramTsova KeterYG"

SRC_URI="mirror://sourceforge/culmus/${P}.tar.gz
	mirror://sourceforge/culmus/${PN}-type1-${TYPE1_PV}.tar.gz
	fontforge? ( mirror://sourceforge/culmus/${PN}-src-${PV}.tar.gz )
	ancient? ( !fontforge? ( mirror://sourceforge/culmus/${MY_A_P}.TTF.tgz )
		fontforge? ( mirror://sourceforge/culmus/${MY_A_P}.tgz ) )"
SRC_URI+=" fancy? ( $(printf "https://culmus.sourceforge.io/fancy/%s.tar.gz " ${FANCY_FONTS}) )"
SRC_URI+=" fancy? ( $(printf "https://culmus.sourceforge.io/fancy-yg/%s.zip " ${FANCY_YG_FONTS}) )"
SRC_URI+=" taamey? ( $(printf "https://culmus.sourceforge.io/taamim/%s.zip " ${TAAMEY_FONTS}) )"
S="${WORKDIR}"

# Some fonts are available in otf format too. Do we need them?
#	https://culmus.sourceforge.io/fancy/anka-otf.zip
#	https://culmus.sourceforge.io/fancy/hillel-otf.zip
#	https://culmus.sourceforge.io/fancy/journal-otf.zip

LICENSE="|| ( GPL-2 LICENSE-BITSTREAM ) ancient? ( MIT ) fancy? ( GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="ancient fancy fontforge taamey"

RDEPEND="!media-fonts/culmus-ancient"
# >=x11-apps/mkfontscale-1.0.9-r1 as Heavy weight support is required
BDEPEND="
	app-arch/unzip
	>=x11-apps/mkfontscale-1.0.9-r1
	fontforge? ( media-gfx/fontforge )
"

FONT_CONF=( "${T}/65-culmus.conf" )
# Put all fonts, generated or not here
FONT_S=${S}/FONTS

src_unpack() {
	unpack ${P}.tar.gz # For type1 fonts...
	unpack ${PN}-type1-${TYPE1_PV}.tar.gz
	use fontforge && unpack ${PN}-src-${PV}.tar.gz

	use ancient && unpack ${MY_A_P}$(use fontforge || echo .TTF).tgz

	if use fancy; then
		unpack $(printf "%s.tar.gz " ${FANCY_FONTS})
		unpack $(printf "%s.zip " ${FANCY_YG_FONTS})
		mv TTF/* . || die
	fi

	if use taamey; then
		for font in ${TAAMEY_FONTS}; do
			mkdir ${font} || die
			pushd ${font} || die
			unpack ${font}.zip
			popd >/dev/null || die
		done
	fi
}

src_prepare() {
	default
	cp "${P}/culmus.conf" "${T}/65-culmus.conf" || die
}

src_compile() {
	mkdir -p "${FONT_S}"
	if use fontforge; then
		pushd ${P} || die

		mv *.afm *.pfa "${FONT_S}" || die
		rm *.ttf || die

		popd >/dev/null || die

		pushd ${PN}-type1-${TYPE1_PV} || die

		mv *.afm *.pfa "${FONT_S}" || die

		popd >/dev/null || die

		pushd ${PN}-src-${PV} || die

		for f in *.sfd; do
			"${WORKDIR}"/${PN}-src-${PV}/GenerateTTF.pe ${f} "${FONT_S}" || die
		done

		popd >/dev/null || die

		if use ancient; then
			pushd ${MY_A_P}/src || die

			export FONTFORGE_LANGUAGE=ff

			emake clean
			emake all

			mv *.ttf "${FONT_S}" || die

			popd >/dev/null || die
		fi

		if use taamey; then
			for font in ${TAAMEY_FONTS}; do
				rm -rf ${font}/TTF || die

				pushd ${font}/SFD || die

				for f in *.sfd; do
					"${WORKDIR}"/${PN}-src-${PV}/GenerateTTF.pe ${f} "${FONT_S}" || die
				done

				popd >/dev/null || die
			done
		fi
	else
		pushd ${P} || die

		mv *.afm *.pfa *.ttf "${FONT_S}" || die

		popd >/dev/null || die

		pushd ${PN}-type1-${TYPE1_PV} || die

		mv *.afm *.pfa "${FONT_S}" || die

		popd >/dev/null || die

		if use ancient; then
			pushd ${MY_A_P}$(use fontforge || echo .TTF)/fonts || die

			mv *.ttf "${FONT_S}" || die

			popd >/dev/null || die
		fi

		if use taamey; then
			for font in ${TAAMEY_FONTS}; do
				pushd ${font}/TTF || die

				mv *.ttf "${FONT_S}" || die

				popd >/dev/null || die
			done
		fi
	fi

	if use fancy; then
		mv *.afm *.pfa *.ttf "${FONT_S}" || die
	fi
}

src_install() {
	einstalldocs

	FONT_SUFFIX="pfa afm $(use fancy || use taamey && echo ttf)" \
		font_src_install

	rm -rf "${FONT_S}" || die
	find "${WORKDIR}" -name '*.ttf' -o -name '*.pfa' -o -name '*.pfm' |
		while read font; do
			eqawarn "Missed font file: ${font}"
		done

	pushd ${PN}$(use fontforge && echo -src)-${PV} || die

	dodoc CHANGES

	popd >/dev/null || die

	if use ancient; then
		pushd "${WORKDIR}/${MY_A_P}$(use fontforge || echo .TTF)/" || die

		newdoc CHANGES{,.ancient}
		newdoc README{,.ancient}

		popd >/dev/null || die
	fi

	if use taamey; then
		for font in ${TAAMEY_FONTS}; do
			pushd ${font} || die

			[[ -f ChangeLog ]] && newdoc ChangeLog{,.${font}}
			newdoc README{,.${font}}
			docinto ${font}
			dodoc -r Samples

			popd >/dev/null || die
		done
	fi
}
