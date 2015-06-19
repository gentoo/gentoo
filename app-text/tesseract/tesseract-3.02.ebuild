# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tesseract/tesseract-3.02.ebuild,v 1.4 2014/08/21 11:35:02 armin76 Exp $

EAPI=4

MY_PN="${PN}-ocr"
MY_P="${MY_PN}-${PV}"
URI_PREFIX="http://${MY_PN}.googlecode.com/files"

inherit eutils autotools versionator

MY_MINOR=$(get_after_major_version)
S="${WORKDIR}/${P}.${MY_MINOR}"

DESCRIPTION="An OCR Engine that was developed at HP and now at Google"
HOMEPAGE="http://code.google.com/p/tesseract-ocr/"
SRC_URI="${URI_PREFIX}/${P}.${MY_MINOR}.tar.gz
	${URI_PREFIX}/${MY_P}.eng.tar.gz
	doc? ( ${URI_PREFIX}/${MY_P}.${MY_MINOR}-doc-html.tar.gz )
	linguas_ar? ( ${URI_PREFIX}/${MY_P}.ara.tar.gz )
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
	linguas_he? ( ${URI_PREFIX}/${MY_P}.heb.tar.gz
				${URI_PREFIX}/${MY_PN}-3.01.heb-com.tar.gz )
	linguas_hi? ( ${URI_PREFIX}/${MY_P}.hin.tar.gz )
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
	linguas_th? ( ${URI_PREFIX}/${MY_P}.tha.tar.gz )
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
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"

IUSE="doc examples jpeg png tiff -webp +scrollview linguas_ar linguas_bg linguas_ca linguas_chr linguas_cs linguas_de linguas_da linguas_el linguas_es linguas_fi linguas_fr linguas_he linguas_hi linguas_hu linguas_id linguas_it linguas_jp linguas_ko linguas_lt linguas_lv linguas_nl linguas_no linguas_pl linguas_pt linguas_ro linguas_ru linguas_sk linguas_sl linguas_sr linguas_sv linguas_th linguas_tl linguas_tr linguas_uk linguas_vi linguas_zh_CN linguas_zh_TW osd"

DEPEND="media-libs/leptonica[zlib,tiff?,jpeg?,png?,webp?]"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/tesseract-2.04-gcc47.patch"
	epatch "${FILESDIR}/tesseract-3.02-automake-compat.patch"
	epatch_user

	eautoreconf
}

src_configure() {
	econf $(use_enable scrollview graphics) \
			--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog NEWS README ReleaseNotes

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
