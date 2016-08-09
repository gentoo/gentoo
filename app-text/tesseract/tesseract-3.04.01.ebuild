# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="tesseract-ocr"
LANGPACKV="3.04.00"
URI_PREFIX="https://github.com/${MY_PN}/tessdata/raw/${LANGPACKV}/"
JAVA_PKG_OPT_USE="scrollview"

inherit eutils autotools java-pkg-opt-2

DESCRIPTION="An OCR Engine, orginally developed at HP, now open source."
HOMEPAGE="https://github.com/tesseract-ocr"
SRC_URI="https://github.com/${MY_PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${URI_PREFIX}eng.traineddata -> eng.traineddata-${LANGPACKV}
	doc? ( https://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.02.02-doc-html.tar.gz )
	math? ( ${URI_PREFIX}equ.traineddata -> equ.traineddata-${LANGPACKV} )
	linguas_ar? ( ${URI_PREFIX}ara.traineddata -> ara.traineddata-${LANGPACKV} )
	linguas_bg? ( ${URI_PREFIX}bul.traineddata -> bul.traineddata-${LANGPACKV} )
	linguas_ca? ( ${URI_PREFIX}cat.traineddata -> cat.traineddata-${LANGPACKV} )
	linguas_chr? ( ${URI_PREFIX}chr.traineddata -> chr.traineddata-${LANGPACKV} )
	linguas_cs? ( ${URI_PREFIX}ces.traineddata -> ces.traineddata-${LANGPACKV} )
	linguas_de? ( ${URI_PREFIX}deu.traineddata -> deu.traineddata-${LANGPACKV}
				  ${URI_PREFIX}deu_frak.traineddata -> deu_frak.traineddata-${LANGPACKV} )
	linguas_da? ( ${URI_PREFIX}dan.traineddata -> dan.traineddata-${LANGPACKV}
				  ${URI_PREFIX}dan_frak.traineddata -> dan_frak.traineddata-${LANGPACKV} )
	linguas_el? ( ${URI_PREFIX}ell.traineddata -> ell.traineddata-${LANGPACKV} )
	linguas_es? ( ${URI_PREFIX}spa.traineddata -> spa.traineddata-${LANGPACKV} )
	linguas_fi? ( ${URI_PREFIX}fin.traineddata -> fin.traineddata-${LANGPACKV} )
	linguas_fr? ( ${URI_PREFIX}fra.traineddata -> fra.traineddata-${LANGPACKV} )
	linguas_he? ( ${URI_PREFIX}heb.traineddata -> heb.traineddata-${LANGPACKV} )
	linguas_hi? ( ${URI_PREFIX}hin.traineddata -> hin.traineddata-${LANGPACKV} )
	linguas_hu? ( ${URI_PREFIX}hun.traineddata -> hun.traineddata-${LANGPACKV} )
	linguas_id? ( ${URI_PREFIX}ind.traineddata -> ind.traineddata-${LANGPACKV} )
	linguas_it? ( ${URI_PREFIX}ita.traineddata -> ita.traineddata-${LANGPACKV} )
	linguas_ja? ( ${URI_PREFIX}jpn.traineddata -> jpn.traineddata-${LANGPACKV} )
	linguas_ko? ( ${URI_PREFIX}kor.traineddata -> kor.traineddata-${LANGPACKV} )
	linguas_lt? ( ${URI_PREFIX}lit.traineddata -> lit.traineddata-${LANGPACKV} )
	linguas_lv? ( ${URI_PREFIX}lav.traineddata -> lav.traineddata-${LANGPACKV} )
	linguas_nl? ( ${URI_PREFIX}nld.traineddata -> nld.traineddata-${LANGPACKV} )
	linguas_no? ( ${URI_PREFIX}nor.traineddata -> nor.traineddata-${LANGPACKV} )
	linguas_pl? ( ${URI_PREFIX}pol.traineddata -> pol.traineddata-${LANGPACKV} )
	linguas_pt? ( ${URI_PREFIX}por.traineddata -> por.traineddata-${LANGPACKV} )
	linguas_ro? ( ${URI_PREFIX}ron.traineddata -> ron.traineddata-${LANGPACKV} )
	linguas_ru? ( ${URI_PREFIX}rus.traineddata -> rus.traineddata-${LANGPACKV} )
	linguas_sk? ( ${URI_PREFIX}slk.traineddata -> slk.traineddata-${LANGPACKV}
				  ${URI_PREFIX}slk_frak.traineddata -> slk_frak.traineddata-${LANGPACKV} )
	linguas_sl? ( ${URI_PREFIX}slv.traineddata -> slv.traineddata-${LANGPACKV} )
	linguas_sr? ( ${URI_PREFIX}srp.traineddata -> srp.traineddata-${LANGPACKV} )
	linguas_sv? ( ${URI_PREFIX}swe.traineddata -> swe.traineddata-${LANGPACKV} )
	linguas_th? ( ${URI_PREFIX}tha.traineddata -> tha.traineddata-${LANGPACKV} )
	linguas_tl? ( ${URI_PREFIX}tgl.traineddata -> tgl.traineddata-${LANGPACKV} )
	linguas_tr? ( ${URI_PREFIX}tur.traineddata -> tur.traineddata-${LANGPACKV} )
	linguas_uk? ( ${URI_PREFIX}ukr.traineddata -> ukr.traineddata-${LANGPACKV} )
	linguas_vi? ( ${URI_PREFIX}vie.traineddata -> vie.traineddata-${LANGPACKV} )
	linguas_zh_CN? ( ${URI_PREFIX}chi_sim.traineddata -> chi_sim.traineddata-${LANGPACKV} )
	linguas_zh_TW? ( ${URI_PREFIX}chi_tra.traineddata -> chi_tra.traineddata-${LANGPACKV} )
	osd? ( ${URI_PREFIX}osd.traineddata -> osd.traineddata-${LANGPACKV} )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"

IUSE="doc examples jpeg math opencl osd png +scrollview static-libs tiff training -webp linguas_ar linguas_bg linguas_ca linguas_chr linguas_cs linguas_de linguas_da linguas_el linguas_es linguas_fi linguas_fr linguas_he linguas_hi linguas_hu linguas_id linguas_it linguas_ja linguas_ko linguas_lt linguas_lv linguas_nl linguas_no linguas_pl linguas_pt linguas_ro linguas_ru linguas_sk linguas_sl linguas_sr linguas_sv linguas_th linguas_tl linguas_tr linguas_uk linguas_vi linguas_zh_CN linguas_zh_TW"

# With opencl USE=tiff is necessary in leptonica
CDEPEND=">=media-libs/leptonica-1.71:=[zlib,tiff?,jpeg?,png?,webp?]
	opencl? (
		virtual/opencl
		media-libs/tiff:0=
		media-libs/leptonica:=[tiff]
	)
	scrollview? (
		>=dev-java/piccolo2d-3.0:0
	)
	training? (
		dev-libs/icu:=
		x11-libs/pango:=
		x11-libs/cairo:=
	)
"

DEPEND="${CDEPEND}
	scrollview? ( >=virtual/jdk-1.7 )"

RDEPEND="${CDEPEND}
	scrollview? ( >=virtual/jre-1.7 )"

DOCS=(AUTHORS ChangeLog NEWS README.md ReleaseNotes )

PATCHES=(
	"${FILESDIR}/tesseract-2.04-gcc47.patch"
	"${FILESDIR}/${P}-use-system-piccolo2d.patch"
)

src_unpack() {
	unpack ${P}.tar.gz
	use doc && unpack tesseract-ocr-3.02.02-doc-html.tar.gz
	find "${DISTDIR}/" -name "*traineddata-${LANGPACKV}" \
		 -execdir sh -c 'cp -- "$0" "${S}/tessdata/${0%-*}"' '{}' ';' || die
}

src_prepare() {
	epatch "${PATCHES[@]}"
	eautoreconf

	java-pkg-opt-2_src_prepare
}

src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_enable opencl)
		$(use_enable scrollview graphics)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	use scrollview && emake ScrollView.jar JAVAC="javac $(java-pkg_javac-args)"
	use training && emake training
}

src_install() {
	default
	prune_libtool_files

	if use training; then
		emake DESTDIR="${D}" training-install
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins testing/eurotext.tif testing/phototest.tif
	fi

	if use doc; then
		dohtml -r "${WORKDIR}/${MY_PN}"/doc/html/*
	fi

	insinto /usr/share/tessdata
	doins tessdata/*traineddata* # language files
	use scrollview && doins java/ScrollView.jar # scrollview
}
