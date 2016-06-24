# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="${PN}-ocr"
DL_P="${MY_PN}-3.02"
URI_PREFIX="https://${MY_PN}.googlecode.com/files"

inherit eutils autotools autotools-utils versionator

S="${WORKDIR}/${PN}-$(get_version_component_range 1-2 )"

DESCRIPTION="An OCR Engine that was developed at HP and now at Google"
HOMEPAGE="https://code.google.com/p/tesseract-ocr/"
SRC_URI="https://dev.gentoo.org/~tomka/files/${PN}-3.03-rc1.tar.gz
	${URI_PREFIX}/${DL_P}.eng.tar.gz
	doc? ( ${URI_PREFIX}/${DL_P}.02-doc-html.tar.gz )
	l10n_ar? ( ${URI_PREFIX}/${DL_P}.ara.tar.gz )
	l10n_bg? ( ${URI_PREFIX}/bul.traineddata.gz )
	l10n_ca? ( ${URI_PREFIX}/cat.traineddata.gz )
	l10n_chr? ( ${URI_PREFIX}/chr.traineddata.gz )
	l10n_cs? ( ${URI_PREFIX}/ces.traineddata.gz )
	l10n_de? ( ${URI_PREFIX}/deu.traineddata.gz
			   ${URI_PREFIX}/deu-frak.traineddata.gz )
	l10n_da? ( ${URI_PREFIX}/dan.traineddata.gz
			   ${URI_PREFIX}/dan-frak.traineddata.gz )
	l10n_el? ( ${URI_PREFIX}/ell.traineddata.gz )
	l10n_es? ( ${URI_PREFIX}/spa.traineddata.gz )
	l10n_fi? ( ${URI_PREFIX}/fin.traineddata.gz )
	l10n_fr? ( ${URI_PREFIX}/fra.traineddata.gz )
	l10n_he? ( ${URI_PREFIX}/${DL_P}.heb.tar.gz
			   ${URI_PREFIX}/${MY_PN}-3.01.heb-com.tar.gz )
	l10n_hi? ( ${URI_PREFIX}/${DL_P}.hin.tar.gz )
	l10n_hu? ( ${URI_PREFIX}/hun.traineddata.gz )
	l10n_id? ( ${URI_PREFIX}/ind.traineddata.gz )
	l10n_it? ( ${URI_PREFIX}/ita.traineddata.gz )
	l10n_ja? ( ${URI_PREFIX}/jpn.traineddata.gz )
	l10n_ko? ( ${URI_PREFIX}/kor.traineddata.gz )
	l10n_lt? ( ${URI_PREFIX}/lit.traineddata.gz )
	l10n_lv? ( ${URI_PREFIX}/lav.traineddata.gz )
	l10n_nl? ( ${URI_PREFIX}/nld.traineddata.gz )
	l10n_no? ( ${URI_PREFIX}/nor.traineddata.gz )
	l10n_pl? ( ${URI_PREFIX}/pol.traineddata.gz )
	l10n_pt? ( ${URI_PREFIX}/por.traineddata.gz )
	l10n_ro? ( ${URI_PREFIX}/ron.traineddata.gz )
	l10n_ru? ( ${URI_PREFIX}/rus.traineddata.gz )
	l10n_sk? ( ${URI_PREFIX}/slk.traineddata.gz
			   ${URI_PREFIX}/${MY_PN}-3.01.slk-frak.tar.gz )
	l10n_sl? ( ${URI_PREFIX}/slv.traineddata.gz )
	l10n_sr? ( ${URI_PREFIX}/srp.traineddata.gz )
	l10n_sv? ( ${URI_PREFIX}/swe.traineddata.gz
			   ${URI_PREFIX}/swe-frak.traineddata.gz )
	l10n_th? ( ${URI_PREFIX}/${DL_P}.tha.tar.gz )
	l10n_tl? ( ${URI_PREFIX}/tgl.traineddata.gz )
	l10n_tr? ( ${URI_PREFIX}/tur.traineddata.gz )
	l10n_uk? ( ${URI_PREFIX}/ukr.traineddata.gz )
	l10n_vi? ( ${URI_PREFIX}/vie.traineddata.gz )
	l10n_zh-CN? ( ${URI_PREFIX}/chi_sim.traineddata.gz )
	l10n_zh-TW? ( ${URI_PREFIX}/chi_tra.traineddata.gz )
	osd? ( ${URI_PREFIX}/${MY_PN}-3.01.osd.tar.gz )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~mips ~ppc ppc64 ~sparc ~x86"

IUSE="doc examples jpeg png tiff -webp +scrollview static-libs l10n_ar l10n_bg l10n_ca l10n_chr l10n_cs l10n_de l10n_da l10n_el l10n_es l10n_fi l10n_fr l10n_he l10n_hi l10n_hu l10n_id l10n_it l10n_ja l10n_ko l10n_lt l10n_lv l10n_nl l10n_no l10n_pl l10n_pt l10n_ro l10n_ru l10n_sk l10n_sl l10n_sr l10n_sv l10n_th l10n_tl l10n_tr l10n_uk l10n_vi l10n_zh-CN l10n_zh-TW osd"

DEPEND=">=media-libs/leptonica-1.70[zlib,tiff?,jpeg?,png?,webp?]"
RDEPEND="${DEPEND}"

DOCS=(AUTHORS ChangeLog NEWS README ReleaseNotes )

PATCHES=(
	"${FILESDIR}/tesseract-2.04-gcc47.patch"
)

src_configure() {
	local myeconfargs=(
		$(use_enable scrollview graphics) \
			--disable-dependency-tracking
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins eurotext.tif phototest.tif
	fi

	if use doc; then
		dohtml -r "${WORKDIR}"/"${MY_PN}"/doc/html/*
	fi

	# install language files
	insinto /usr/share/tessdata
	find "${WORKDIR}" -maxdepth 1 -type f -name "*.traineddata" -exec doins '{}' +
	doins "${WORKDIR}"/"${MY_PN}"/tessdata/*
}
