# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tesseract/tesseract-3.04.00-r1.ebuild,v 1.2 2015/08/03 15:29:30 tomka Exp $

EAPI=5

MY_PN="tesseract-ocr"
URI_PREFIX="https://github.com/${MY_PN}/tessdata/tree/${PV}/"

inherit eutils autotools autotools-utils

DESCRIPTION="An OCR Engine, orginally developed at HP, now open source."
HOMEPAGE="https://github.com/tesseract-ocr"
SRC_URI="https://github.com/${MY_PN}/${PN}/archive/${PV}.tar.gz
	${URI_PREFIX}/eng.traineddata
	doc? ( http://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.02.02-doc-html.tar.gz )
	linguas_ar? ( ${URI_PREFIX}/ara.traineddata )
	linguas_bg? ( ${URI_PREFIX}/bul.traineddata )
	linguas_ca? ( ${URI_PREFIX}/cat.traineddata )
	linguas_chr? ( ${URI_PREFIX}/chr.traineddata )
	linguas_cs? ( ${URI_PREFIX}/ces.traineddata )
	linguas_de? ( ${URI_PREFIX}/deu.traineddata
				${URI_PREFIX}/deu_frak.traineddata )
	linguas_da? ( ${URI_PREFIX}/dan.traineddata
				${URI_PREFIX}/dan_frak.traineddata )
	linguas_el? ( ${URI_PREFIX}/ell.traineddata )
	linguas_es? ( ${URI_PREFIX}/spa.traineddata )
	linguas_fi? ( ${URI_PREFIX}/fin.traineddata )
	linguas_fr? ( ${URI_PREFIX}/fra.traineddata )
	linguas_he? ( ${URI_PREFIX}/heb.traineddata )
	linguas_hi? ( ${URI_PREFIX}/hin.traineddata )
	linguas_hu? ( ${URI_PREFIX}/hun.traineddata )
	linguas_id? ( ${URI_PREFIX}/ind.traineddata )
	linguas_it? ( ${URI_PREFIX}/ita.traineddata )
	linguas_jp? ( ${URI_PREFIX}/jpn.traineddata )
	linguas_ko? ( ${URI_PREFIX}/kor.traineddata )
	linguas_lt? ( ${URI_PREFIX}/lit.traineddata )
	linguas_lv? ( ${URI_PREFIX}/lav.traineddata )
	linguas_nl? ( ${URI_PREFIX}/nld.traineddata )
	linguas_no? ( ${URI_PREFIX}/nor.traineddata )
	linguas_pl? ( ${URI_PREFIX}/pol.traineddata )
	linguas_pt? ( ${URI_PREFIX}/por.traineddata )
	linguas_ro? ( ${URI_PREFIX}/ron.traineddata )
	linguas_ru? ( ${URI_PREFIX}/rus.traineddata )
	linguas_sk? ( ${URI_PREFIX}/slk.traineddata
				${URI_PREFIX}/slk_frak.traineddata )
	linguas_sl? ( ${URI_PREFIX}/slv.traineddata )
	linguas_sr? ( ${URI_PREFIX}/srp.traineddata )
	linguas_sv? ( ${URI_PREFIX}/swe.traineddata )
	linguas_th? ( ${URI_PREFIX}/tha.traineddata )
	linguas_tl? ( ${URI_PREFIX}/tgl.traineddata )
	linguas_tr? ( ${URI_PREFIX}/tur.traineddata )
	linguas_uk? ( ${URI_PREFIX}/ukr.traineddata )
	linguas_vi? ( ${URI_PREFIX}/vie.traineddata )
	linguas_zh_CN? ( ${URI_PREFIX}/chi_sim.traineddata )
	linguas_zh_TW? ( ${URI_PREFIX}/chi_tra.traineddata )
	osd? ( ${URI_PREFIX}/osd.traineddata )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"

IUSE="doc examples jpeg opencl osd png +scrollview static-libs tiff -webp linguas_ar linguas_bg linguas_ca linguas_chr linguas_cs linguas_de linguas_da linguas_el linguas_es linguas_fi linguas_fr linguas_he linguas_hi linguas_hu linguas_id linguas_it linguas_jp linguas_ko linguas_lt linguas_lv linguas_nl linguas_no linguas_pl linguas_pt linguas_ro linguas_ru linguas_sk linguas_sl linguas_sr linguas_sv linguas_th linguas_tl linguas_tr linguas_uk linguas_vi linguas_zh_CN linguas_zh_TW"

# With opencl tiff is necessary regardless of leptonica status   <-- Check this
DEPEND=">=media-libs/leptonica-1.70[zlib,tiff?,jpeg?,png?,webp?]
		opencl? ( virtual/opencl
				  media-libs/tiff:0 )"
RDEPEND="${DEPEND}"

DOCS=(AUTHORS ChangeLog NEWS README ReleaseNotes )

PATCHES=(
	"${FILESDIR}/tesseract-2.04-gcc47.patch"
)

src_unpack() {
	unpack ${PV}.tar.gz
	use doc && unpack tesseract-ocr-3.02.02-doc-html.tar.gz
	mkdir "${WORKDIR}"/tesseract-ocr/tessdata || die
	cp "${DISTDIR}"/*.traineddata "${WORKDIR}"/tesseract-ocr/tessdata/ || die
}

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
		doins testing/eurotext.tif testing/phototest.tif
	fi

	if use doc; then
		dohtml -r "${WORKDIR}"/"${MY_PN}"/doc/html/*
	fi

	# install language files
	insinto /usr/share/tessdata
	find "${WORKDIR}" -maxdepth 1 -type f -name "*.traineddata" -exec doins '{}' +
	doins "${WORKDIR}"/"${MY_PN}"/tessdata/*
}
