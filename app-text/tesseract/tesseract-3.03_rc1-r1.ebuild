# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tesseract/tesseract-3.03_rc1-r1.ebuild,v 1.4 2015/05/10 18:20:41 jer Exp $

EAPI=5

MY_PN="${PN}-ocr"
DL_P="${MY_PN}-3.02"
URI_PREFIX="http://${MY_PN}.googlecode.com/files"

inherit eutils autotools autotools-utils versionator

S="${WORKDIR}/${PN}-$(get_version_component_range 1-2 )"

DESCRIPTION="An OCR Engine that was developed at HP and now at Google"
HOMEPAGE="http://code.google.com/p/tesseract-ocr/"
SRC_URI="http://dev.gentoo.org/~tomka/files/${PN}-3.03-rc1.tar.gz
	${URI_PREFIX}/${DL_P}.eng.tar.gz
	doc? ( ${URI_PREFIX}/${DL_P}.02-doc-html.tar.gz )
	linguas_ar? ( ${URI_PREFIX}/${DL_P}.ara.tar.gz )
	linguas_bg? ( ${URI_PREFIX}/bul.traineddata.gz )
	linguas_ca? ( ${URI_PREFIX}/cat.traineddata.gz )
	linguas_chr? ( ${URI_PREFIX}/chr.traineddata.gz )
	linguas_cs? ( ${URI_PREFIX}/ces.traineddata.gz )
	linguas_de? ( ${URI_PREFIX}/deu.traineddata.gz
				${URI_PREFIX}/deu-frak.traineddata.gz )
	linguas_da? ( ${URI_PREFIX}/dan.traineddata.gz
				${URI_PREFIX}/dan-frak.traineddata.gz )
	linguas_el? ( ${URI_PREFIX}/ell.traineddata.gz )
	linguas_es? ( ${URI_PREFIX}/spa.traineddata.gz )
	linguas_fi? ( ${URI_PREFIX}/fin.traineddata.gz )
	linguas_fr? ( ${URI_PREFIX}/fra.traineddata.gz )
	linguas_he? ( ${URI_PREFIX}/${DL_P}.heb.tar.gz
				${URI_PREFIX}/${MY_PN}-3.01.heb-com.tar.gz )
	linguas_hi? ( ${URI_PREFIX}/${DL_P}.hin.tar.gz )
	linguas_hu? ( ${URI_PREFIX}/hun.traineddata.gz )
	linguas_id? ( ${URI_PREFIX}/ind.traineddata.gz )
	linguas_it? ( ${URI_PREFIX}/ita.traineddata.gz )
	linguas_jp? ( ${URI_PREFIX}/jpn.traineddata.gz )
	linguas_ko? ( ${URI_PREFIX}/kor.traineddata.gz )
	linguas_lt? ( ${URI_PREFIX}/lit.traineddata.gz )
	linguas_lv? ( ${URI_PREFIX}/lav.traineddata.gz )
	linguas_nl? ( ${URI_PREFIX}/nld.traineddata.gz )
	linguas_no? ( ${URI_PREFIX}/nor.traineddata.gz )
	linguas_pl? ( ${URI_PREFIX}/pol.traineddata.gz )
	linguas_pt? ( ${URI_PREFIX}/por.traineddata.gz )
	linguas_ro? ( ${URI_PREFIX}/ron.traineddata.gz )
	linguas_ru? ( ${URI_PREFIX}/rus.traineddata.gz )
	linguas_sk? ( ${URI_PREFIX}/slk.traineddata.gz
				${URI_PREFIX}/${MY_PN}-3.01.slk-frak.tar.gz )
	linguas_sl? ( ${URI_PREFIX}/slv.traineddata.gz )
	linguas_sr? ( ${URI_PREFIX}/srp.traineddata.gz )
	linguas_sv? ( ${URI_PREFIX}/swe.traineddata.gz
				${URI_PREFIX}/swe-frak.traineddata.gz )
	linguas_th? ( ${URI_PREFIX}/${DL_P}.tha.tar.gz )
	linguas_tl? ( ${URI_PREFIX}/tgl.traineddata.gz )
	linguas_tr? ( ${URI_PREFIX}/tur.traineddata.gz )
	linguas_uk? ( ${URI_PREFIX}/ukr.traineddata.gz )
	linguas_vi? ( ${URI_PREFIX}/vie.traineddata.gz )
	linguas_zh_CN? ( ${URI_PREFIX}/chi_sim.traineddata.gz )
	linguas_zh_TW? ( ${URI_PREFIX}/chi_tra.traineddata.gz )
	osd? ( ${URI_PREFIX}/${MY_PN}-3.01.osd.tar.gz )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"

IUSE="doc examples jpeg opencl osd png +scrollview static-libs tiff -webp linguas_ar linguas_bg linguas_ca linguas_chr linguas_cs linguas_de linguas_da linguas_el linguas_es linguas_fi linguas_fr linguas_he linguas_hi linguas_hu linguas_id linguas_it linguas_jp linguas_ko linguas_lt linguas_lv linguas_nl linguas_no linguas_pl linguas_pt linguas_ro linguas_ru linguas_sk linguas_sl linguas_sr linguas_sv linguas_th linguas_tl linguas_tr linguas_uk linguas_vi linguas_zh_CN linguas_zh_TW"

# With opencl tiff is necessary regardless of leptonica status
DEPEND=">=media-libs/leptonica-1.70[zlib,tiff?,jpeg?,png?,webp?]
		opencl? ( virtual/opencl
				  media-libs/tiff:0 )"
RDEPEND="${DEPEND}"

DOCS=(AUTHORS ChangeLog NEWS README ReleaseNotes )

PATCHES=(
	"${FILESDIR}/tesseract-2.04-gcc47.patch"
)

src_configure() {
	local myeconfargs=(
		$(use_enable opencl) \
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
