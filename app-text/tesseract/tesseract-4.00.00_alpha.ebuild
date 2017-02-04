# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="tesseract-ocr"
LANGPACKV="4.00"
URI_PREFIX="https://github.com/${MY_PN}/tessdata/raw/${LANGPACKV}/"
JAVA_PKG_OPT_USE="scrollview"

inherit autotools java-pkg-opt-2 toolchain-funcs

DESCRIPTION="An OCR Engine, orginally developed at HP, now open source."
HOMEPAGE="https://github.com/tesseract-ocr"
SRC_URI="https://github.com/${MY_PN}/${PN}/archive/${PV/_}.tar.gz -> ${P}.tar.gz
	${URI_PREFIX}eng.traineddata -> eng.traineddata-${LANGPACKV}
	math? ( ${URI_PREFIX}equ.traineddata -> equ.traineddata-${LANGPACKV} )
	osd? ( ${URI_PREFIX}osd.traineddata -> osd.traineddata-${LANGPACKV} )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc examples jpeg math opencl openmp osd png scrollview static-libs tiff training webp"

# List of supported Gentoo linguas and their upstream mapping
# https://github.com/tesseract-ocr/tesseract/wiki/Data-Files
# "old" variants were regrouped in the matching modern locale
LANGUAGES="af:afr am:amh ar:ara as:asm az:aze,aze_cyrl be:bel bn:ben bo:bod bs:bos bg:bul ca:cat cs:ces zh:chi_sim,chi_tra cy:cym da:dan de:deu,frk dz:dzo el:ell,grc en:enm eo:epo et:est eu:eus fa:fas fi:fin fr:fra,frm ga:gle gl:glg gu:guj he:heb hi:hin hr:hrv hu:hun id:ind is:isl it:ita,ita_old ja:jpn kn:kan ka:kat,kat_old kk:kaz km:khm ky:kir ko:kor ku:kur lo:lao la:lat lv:lav lt:lit ml:mal mr:mar mk:mkd ms:msa my:mya ne:nep nl:nld no:nor or:ori pa:pan pl:pol pt:por ro:ron ru:rus sa:san si:sin sk:slk sl:slv es:spa,spa_old sq:sqi sr:srp,srp_latn sw:swa sv:swe syc:syr ta:tam te:tel tg:tgk tl:tgl th:tha tr:tur ug:uig uk:ukr uz:uzb,uzb_cyrl vi:vie"
# Missing matches:
#	ceb 	Cebuano
#	chr 	Cherokee
#	hat 	Haitian; Haitian Creole
#	iku 	Inuktitut
#	jav 	Javanese
#	mlt 	Maltese
#	pus 	Pushto; Pashto
#	tir 	Tigrinya
#	urd 	Urdu
#	yid 	Yiddish
# l10n_en provides the additional data:
#	enm 	English, Middle (1100-1500)

for lang in ${LANGUAGES}; do
	gentoo_lang=${lang%:*}
	tess_langs=${lang#*:}
	for tess_lang in ${tess_langs//,/ }; do
		SRC_URI+=" l10n_${gentoo_lang}? ( ${URI_PREFIX}${tess_lang}.traineddata -> ${tess_lang}.traineddata-${LANGPACKV} )"
	done
	IUSE+=" l10n_${gentoo_lang}"
done

# With opencl USE=tiff is necessary in leptonica
CDEPEND=">=media-libs/leptonica-1.74:=[zlib,tiff?,jpeg?,png?,webp?]
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
	)"

DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen )
	scrollview? ( >=virtual/jdk-1.7 )"

RDEPEND="${CDEPEND}
	scrollview? ( >=virtual/jre-1.7 )"

DOCS=( AUTHORS ChangeLog NEWS README.md )

PATCHES=(
	"${FILESDIR}/${PN}-3.04.01-use-system-piccolo2d.patch"
	"${FILESDIR}/${P}-isnan.patch"
	"${FILESDIR}/${P}-openmp.patch"
	"${FILESDIR}/${P}-no_graphics.patch"
)

S=${WORKDIR}/${P/_}

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_unpack() {
	unpack ${P}.tar.gz
	for file in ${A}; do
		if [[ "${file}" == *traineddata* ]]; then
			cp "${DISTDIR}/${file}" "${S}/tessdata/${file%-*}" || die
		fi
	done
}

src_prepare() {
	default
	eautoreconf

	java-pkg-opt-2_src_prepare
}

src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_enable opencl)
		$(use_enable openmp)
		$(use_enable scrollview graphics)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	use doc && emake doc
	use scrollview && emake ScrollView.jar JAVAC="javac $(java-pkg_javac-args)"
	use training && emake training
}

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	default
	prune_libtool_files

	if use training; then
		emake DESTDIR="${D}" training-install
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins testing/eurotext.tif testing/phototest.tif
	fi

	insinto /usr/share/tessdata
	doins tessdata/*traineddata* # language files
	use scrollview && doins java/ScrollView.jar # scrollview
}
