# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

URI_PREFIX="https://github.com/tesseract-ocr/${PN}/raw/${PV}/"

DESCRIPTION="Fast integer versions of trained models for app-text/tesseract"
HOMEPAGE="https://github.com/tesseract-ocr/tessdata_fast"
SRC_URI="${URI_PREFIX}eng.traineddata -> eng.traineddata-${P}
	osd? ( ${URI_PREFIX}osd.traineddata -> osd.traineddata-${P} )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+osd"

RDEPEND="!app-text/tessdata_best
	!app-text/tessdata_legacy
	!<app-text/tesseract-4.1.0"
DEPEND="${RDEPEND}"
S=${WORKDIR}

# List of supported Gentoo linguas and their upstream mapping
# "old" variants were regrouped in the matching modern locale
LANGUAGES="af:afr am:amh ar:ara as:asm az:aze,aze_cyrl be:bel bg:bul bn:ben bo:bod br:bre bs:bos ca:cat ceb chr co:cos cs:ces cy:cym da:dan de:deu,frk dv:div dz:dzo el:ell,grc en:enm eo:epo es:spa,spa_old et:est eu:eus fa:fas fi:fin fil fo:fao fr:fra,frm fy:fry ga:gle gd:gla gl:glg gu:guj he:heb hi:hin hr:hrv ht:hat hu:hun hy:hye id:ind is:isl it:ita,ita_old iu:iku ja:jpn,jpn_vert jv:jav ka:kat,kat_old kk:kaz km:khm kmr-Latn:kmr kn:kan ko:kor,kor_vert ky:kir la:lat lb:ltz lo:lao lt:lit lv:lav mi:mri mk:mkd ml:mal mn:mon mr:mar ms:msa mt:mlt my:mya ne:nep nl:nld no:nor oc:oci or:ori pa:pan pl:pol ps:pus pt:por qu:que ro:ron ru:rus sa:san sd:snd si:sin sk:slk sl:slv sq:sqi sr:srp,srp_latn su:sun sv:swe sw:swa syc:syr ta:tam te:tel tg:tgk th:tha ti:tir to:ton tr:tur tt:tat ug:uig uk:ukr ur:urd uz:uzb,uzb_cyrl vi:vie yi:yid yo:yor zh:chi_sim,chi_sim_vert,chi_tra,chi_tra_vert"
# l10n_en provides the additional data:
#	enm - English, Middle (1100-1500)

for lang in ${LANGUAGES}; do
	gentoo_lang=${lang%:*}
	tess_langs=${lang#*:}
	for tess_lang in ${tess_langs//,/ }; do
		SRC_URI+=" l10n_${gentoo_lang}? ( ${URI_PREFIX}${tess_lang}.traineddata -> ${tess_lang}.traineddata-${P} )"
	done
	IUSE+=" l10n_${gentoo_lang}"
done

src_prepare() {
	for file in ${A}; do
		cp "${DISTDIR}/${file}" "${S}/${file/-${P}/}" || die
	done

	default
}

src_install() {
	insinto /usr/share/tessdata
	doins *.traineddata
}
