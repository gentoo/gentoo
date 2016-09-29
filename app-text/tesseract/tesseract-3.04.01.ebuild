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
	l10n_ar? ( ${URI_PREFIX}ara.traineddata -> ara.traineddata-${LANGPACKV} )
	l10n_bg? ( ${URI_PREFIX}bul.traineddata -> bul.traineddata-${LANGPACKV} )
	l10n_ca? ( ${URI_PREFIX}cat.traineddata -> cat.traineddata-${LANGPACKV} )
	l10n_chr? ( ${URI_PREFIX}chr.traineddata -> chr.traineddata-${LANGPACKV} )
	l10n_cs? ( ${URI_PREFIX}ces.traineddata -> ces.traineddata-${LANGPACKV} )
	l10n_de? ( ${URI_PREFIX}deu.traineddata -> deu.traineddata-${LANGPACKV}
				  ${URI_PREFIX}deu_frak.traineddata -> deu_frak.traineddata-${LANGPACKV} )
	l10n_da? ( ${URI_PREFIX}dan.traineddata -> dan.traineddata-${LANGPACKV}
				  ${URI_PREFIX}dan_frak.traineddata -> dan_frak.traineddata-${LANGPACKV} )
	l10n_el? ( ${URI_PREFIX}ell.traineddata -> ell.traineddata-${LANGPACKV} )
	l10n_es? ( ${URI_PREFIX}spa.traineddata -> spa.traineddata-${LANGPACKV} )
	l10n_fi? ( ${URI_PREFIX}fin.traineddata -> fin.traineddata-${LANGPACKV} )
	l10n_fr? ( ${URI_PREFIX}fra.traineddata -> fra.traineddata-${LANGPACKV} )
	l10n_he? ( ${URI_PREFIX}heb.traineddata -> heb.traineddata-${LANGPACKV} )
	l10n_hi? ( ${URI_PREFIX}hin.traineddata -> hin.traineddata-${LANGPACKV} )
	l10n_hu? ( ${URI_PREFIX}hun.traineddata -> hun.traineddata-${LANGPACKV} )
	l10n_id? ( ${URI_PREFIX}ind.traineddata -> ind.traineddata-${LANGPACKV} )
	l10n_it? ( ${URI_PREFIX}ita.traineddata -> ita.traineddata-${LANGPACKV} )
	l10n_ja? ( ${URI_PREFIX}jpn.traineddata -> jpn.traineddata-${LANGPACKV} )
	l10n_ko? ( ${URI_PREFIX}kor.traineddata -> kor.traineddata-${LANGPACKV} )
	l10n_lt? ( ${URI_PREFIX}lit.traineddata -> lit.traineddata-${LANGPACKV} )
	l10n_lv? ( ${URI_PREFIX}lav.traineddata -> lav.traineddata-${LANGPACKV} )
	l10n_nl? ( ${URI_PREFIX}nld.traineddata -> nld.traineddata-${LANGPACKV} )
	l10n_no? ( ${URI_PREFIX}nor.traineddata -> nor.traineddata-${LANGPACKV} )
	l10n_pl? ( ${URI_PREFIX}pol.traineddata -> pol.traineddata-${LANGPACKV} )
	l10n_pt? ( ${URI_PREFIX}por.traineddata -> por.traineddata-${LANGPACKV} )
	l10n_ro? ( ${URI_PREFIX}ron.traineddata -> ron.traineddata-${LANGPACKV} )
	l10n_ru? ( ${URI_PREFIX}rus.traineddata -> rus.traineddata-${LANGPACKV} )
	l10n_sk? ( ${URI_PREFIX}slk.traineddata -> slk.traineddata-${LANGPACKV}
				  ${URI_PREFIX}slk_frak.traineddata -> slk_frak.traineddata-${LANGPACKV} )
	l10n_sl? ( ${URI_PREFIX}slv.traineddata -> slv.traineddata-${LANGPACKV} )
	l10n_sr? ( ${URI_PREFIX}srp.traineddata -> srp.traineddata-${LANGPACKV} )
	l10n_sv? ( ${URI_PREFIX}swe.traineddata -> swe.traineddata-${LANGPACKV} )
	l10n_th? ( ${URI_PREFIX}tha.traineddata -> tha.traineddata-${LANGPACKV} )
	l10n_tl? ( ${URI_PREFIX}tgl.traineddata -> tgl.traineddata-${LANGPACKV} )
	l10n_tr? ( ${URI_PREFIX}tur.traineddata -> tur.traineddata-${LANGPACKV} )
	l10n_uk? ( ${URI_PREFIX}ukr.traineddata -> ukr.traineddata-${LANGPACKV} )
	l10n_vi? ( ${URI_PREFIX}vie.traineddata -> vie.traineddata-${LANGPACKV} )
	l10n_zh-CN? ( ${URI_PREFIX}chi_sim.traineddata -> chi_sim.traineddata-${LANGPACKV} )
	l10n_zh-TW? ( ${URI_PREFIX}chi_tra.traineddata -> chi_tra.traineddata-${LANGPACKV} )
	osd? ( ${URI_PREFIX}osd.traineddata -> osd.traineddata-${LANGPACKV} )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"

IUSE="doc examples jpeg math opencl osd png +scrollview static-libs tiff training -webp l10n_ar l10n_bg l10n_ca l10n_chr l10n_cs l10n_de l10n_da l10n_el l10n_es l10n_fi l10n_fr l10n_he l10n_hi l10n_hu l10n_id l10n_it l10n_ja l10n_ko l10n_lt l10n_lv l10n_nl l10n_no l10n_pl l10n_pt l10n_ro l10n_ru l10n_sk l10n_sl l10n_sr l10n_sv l10n_th l10n_tl l10n_tr l10n_uk l10n_vi l10n_zh-CN l10n_zh-TW"

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
	"${FILESDIR}/${P}-fix-opencl-ldflags.patch"
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
