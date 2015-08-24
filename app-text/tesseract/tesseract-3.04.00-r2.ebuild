# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="tesseract-ocr"
URI_PREFIX="https://github.com/${MY_PN}/tessdata/raw/${PV}/"

inherit eutils autotools autotools-utils

DESCRIPTION="An OCR Engine, orginally developed at HP, now open source."
HOMEPAGE="https://github.com/tesseract-ocr"
SRC_URI="https://github.com/${MY_PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${URI_PREFIX}eng.traineddata -> eng.traineddata-${PV}
	doc? ( https://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.02.02-doc-html.tar.gz )
	linguas_ar? ( ${URI_PREFIX}ara.traineddata -> ara.traineddata-${PV} )
	linguas_bg? ( ${URI_PREFIX}bul.traineddata -> bul.traineddata-${PV} )
	linguas_ca? ( ${URI_PREFIX}cat.traineddata -> cat.traineddata-${PV} )
	linguas_chr? ( ${URI_PREFIX}chr.traineddata -> chr.traineddata-${PV} )
	linguas_cs? ( ${URI_PREFIX}ces.traineddata -> ces.traineddata-${PV} )
	linguas_de? ( ${URI_PREFIX}deu.traineddata -> deu.traineddata-${PV}
				  ${URI_PREFIX}deu_frak.traineddata -> deu_frak.traineddata-${PV} )
	linguas_da? ( ${URI_PREFIX}dan.traineddata -> dan.traineddata-${PV}
				  ${URI_PREFIX}dan_frak.traineddata -> dan_frak.traineddata-${PV} )
	linguas_el? ( ${URI_PREFIX}ell.traineddata -> ell.traineddata-${PV} )
	linguas_es? ( ${URI_PREFIX}spa.traineddata -> spa.traineddata-${PV} )
	linguas_fi? ( ${URI_PREFIX}fin.traineddata -> fin.traineddata-${PV} )
	linguas_fr? ( ${URI_PREFIX}fra.traineddata -> fra.traineddata-${PV} )
	linguas_he? ( ${URI_PREFIX}heb.traineddata -> heb.traineddata-${PV} )
	linguas_hi? ( ${URI_PREFIX}hin.traineddata -> hin.traineddata-${PV} )
	linguas_hu? ( ${URI_PREFIX}hun.traineddata -> hun.traineddata-${PV} )
	linguas_id? ( ${URI_PREFIX}ind.traineddata -> ind.traineddata-${PV} )
	linguas_it? ( ${URI_PREFIX}ita.traineddata -> ita.traineddata-${PV} )
	linguas_jp? ( ${URI_PREFIX}jpn.traineddata -> jpn.traineddata-${PV} )
	linguas_ko? ( ${URI_PREFIX}kor.traineddata -> kor.traineddata-${PV} )
	linguas_lt? ( ${URI_PREFIX}lit.traineddata -> lit.traineddata-${PV} )
	linguas_lv? ( ${URI_PREFIX}lav.traineddata -> lav.traineddata-${PV} )
	linguas_nl? ( ${URI_PREFIX}nld.traineddata -> nld.traineddata-${PV} )
	linguas_no? ( ${URI_PREFIX}nor.traineddata -> nor.traineddata-${PV} )
	linguas_pl? ( ${URI_PREFIX}pol.traineddata -> pol.traineddata-${PV} )
	linguas_pt? ( ${URI_PREFIX}por.traineddata -> por.traineddata-${PV} )
	linguas_ro? ( ${URI_PREFIX}ron.traineddata -> ron.traineddata-${PV} )
	linguas_ru? ( ${URI_PREFIX}rus.traineddata -> rus.traineddata-${PV} )
	linguas_sk? ( ${URI_PREFIX}slk.traineddata -> slk.traineddata-${PV}
				  ${URI_PREFIX}slk_frak.traineddata -> slk_frak.traineddata-${PV} )
	linguas_sl? ( ${URI_PREFIX}slv.traineddata -> slv.traineddata-${PV} )
	linguas_sr? ( ${URI_PREFIX}srp.traineddata -> srp.traineddata-${PV} )
	linguas_sv? ( ${URI_PREFIX}swe.traineddata -> swe.traineddata-${PV} )
	linguas_th? ( ${URI_PREFIX}tha.traineddata -> tha.traineddata-${PV} )
	linguas_tl? ( ${URI_PREFIX}tgl.traineddata -> tgl.traineddata-${PV} )
	linguas_tr? ( ${URI_PREFIX}tur.traineddata -> tur.traineddata-${PV} )
	linguas_uk? ( ${URI_PREFIX}ukr.traineddata -> ukr.traineddata-${PV} )
	linguas_vi? ( ${URI_PREFIX}vie.traineddata -> vie.traineddata-${PV} )
	linguas_zh_CN? ( ${URI_PREFIX}chi_sim.traineddata -> chi_sim.traineddata-${PV} )
	linguas_zh_TW? ( ${URI_PREFIX}chi_tra.traineddata -> chi_tra.traineddata-${PV} )
	osd? ( ${URI_PREFIX}osd.traineddata -> osd.traineddata-${PV} )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"

IUSE="doc examples jpeg opencl osd png +scrollview static-libs tiff training -webp linguas_ar linguas_bg linguas_ca linguas_chr linguas_cs linguas_de linguas_da linguas_el linguas_es linguas_fi linguas_fr linguas_he linguas_hi linguas_hu linguas_id linguas_it linguas_jp linguas_ko linguas_lt linguas_lv linguas_nl linguas_no linguas_pl linguas_pt linguas_ro linguas_ru linguas_sk linguas_sl linguas_sr linguas_sv linguas_th linguas_tl linguas_tr linguas_uk linguas_vi linguas_zh_CN linguas_zh_TW"

# With opencl tiff is necessary regardless of leptonica status   <-- Check this
DEPEND=">=media-libs/leptonica-1.70[zlib,tiff?,jpeg?,png?,webp?]
		opencl? ( virtual/opencl
				  media-libs/tiff:0 )
	training? (
	  dev-libs/icu
	  x11-libs/pango
	  x11-libs/cairo
	)
"
RDEPEND="${DEPEND}"

DOCS=(AUTHORS ChangeLog NEWS README ReleaseNotes )

PATCHES=(
	"${FILESDIR}/tesseract-2.04-gcc47.patch"
	"${FILESDIR}/${P}-fix-scrollview-disabled.patch"
)

src_unpack() {
	unpack ${P}.tar.gz
	use doc && unpack tesseract-ocr-3.02.02-doc-html.tar.gz
	find "${DISTDIR}/" -name "*traineddata-${PV}" \
		 -execdir sh -c 'cp -- "$0" "${S}/tessdata/${0%-*}"' '{}' ';' || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable opencl) \
		$(use_enable scrollview graphics)
		)
	autotools-utils_src_configure
}

src_compile() {
	default
	if use training; then
		emake training
	fi
	}

src_install() {
	autotools-utils_src_install

	if use training; then
		pushd "${BUILD_DIR}"
		emake DESTDIR="${D}" training-install
		popd
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins testing/eurotext.tif testing/phototest.tif
	fi

	if use doc; then
		dohtml -r "${WORKDIR}"/"${MY_PN}"/doc/html/*
	fi

	# install language files
	insinto /usr/share/tessdata
	doins "${S}"/tessdata/*traineddata*
}
