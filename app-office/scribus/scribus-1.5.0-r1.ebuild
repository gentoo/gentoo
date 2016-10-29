# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk?"

inherit cmake-utils fdo-mime flag-o-matic multilib python-single-r1

DESCRIPTION="Desktop publishing (DTP) and layout program"
HOMEPAGE="http://www.scribus.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}-devel/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+boost debug examples graphicsmagick hunspell +minimal osg +pdf scripts templates tk"

#a=$((ls resources/translations/scribus.*ts | sed -e 's:\.: :g' | awk '{print $2}'; ls resources/loremipsum/*xml | sed -e 's:\.: :g' -e 's:loremipsum\/: :g'| awk '{print $2}'; ls resources/dicts/hyph*dic | sed -e 's:\.: :g' -e 's:hyph_: :g' | awk '{print $2}'; ls resources/dicts/README_*txt | sed -e 's:_hyph::g' -e 's:\.: :g' -e 's:README_: :g' | awk '{print $2}') | sort | uniq); echo $a
IUSE_LINGUAS=" af ar bg br ca ca_ES cs cs_CZ cy cy_GB da da_DK de de@1901 de_CH de_DE el en_AU en_GB en_US eo es es_ES et eu fi fi_FI fr gl he hr hu hu_HU ia id id_ID is is_IS it ja ko ku la lt lt_LT nb_NO nl nn_NO pl pl_PL pt pt_BR pt_PT ro ro_RO ru ru_RU sa sk sk_SK sl sl_SI sq sr sv sv_SE th_TH tr uk uk_UA zh_CN zh_TW"
IUSE+=" ${IUSE_LINGUAS// / linguas_}"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	tk? ( scripts )"

# osg
# couple of third_party libs bundled
COMMON_DEPEND="
	${PYTHON_DEPS}
	app-text/libmspub
	>=app-text/poppler-0.19.0:=
	dev-libs/boost
	dev-libs/hyphen
	dev-libs/librevenge
	dev-libs/libxml2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/lcms:2
	media-libs/libcdr
	media-libs/libpagemaker
	media-libs/libpng:0
	media-libs/libvisio
	media-libs/tiff:0
	net-print/cups
	sys-libs/zlib[minizip]
	virtual/jpeg:0=
	>=x11-libs/cairo-1.10.0[X,svg]
	boost? ( dev-libs/boost )
	hunspell? ( app-text/hunspell )
	graphicsmagick? ( media-gfx/graphicsmagick )
	osg? ( dev-games/openscenegraph )
	pdf? ( app-text/podofo:0= )
	scripts? ( dev-python/pillow[tk?,${PYTHON_USEDEP}] )
	tk? ( dev-python/pillow[tk?,${PYTHON_USEDEP}] )
"
RDEPEND="${COMMON_DEPEND}
	app-text/ghostscript-gpl"
DEPEND="${COMMON_DEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-docdir.patch
	"${FILESDIR}"/${P}-fpic.patch
	"${FILESDIR}"/${P}-QObject.patch
	)

src_prepare() {
	rm -r codegen/cheetah || die
	cat > cmake/modules/FindZLIB.cmake <<- EOF
	find_package(PkgConfig)
	pkg_check_modules(ZLIB minizip zlib)
	SET( ZLIB_LIBRARY \${ZLIB_LIBRARIES} )
	SET( ZLIB_INCLUDE_DIR \${ZLIB_INCLUDE_DIRS} )
	MARK_AS_ADVANCED( ZLIB_LIBRARY ZLIB_INCLUDE_DIR )
	EOF

	sed \
		-e "/^\s*unzip\.[ch]/d" \
		-e "/^\s*ioapi\.[ch]/d" \
		-i scribus/CMakeLists.txt Scribus.pro || die
	rm scribus/ioapi.[ch] || die

	sed \
		-e 's:\(${CMAKE_INSTALL_PREFIX}\):./\1:g' \
		-i resources/templates/CMakeLists.txt || die

	if has_version ">=dev-qt/qtcore-5.7.0" ; then
		append-cxxflags "-std=c++11" #bug 591948
	fi

	cmake-utils_src_prepare
}

src_configure() {
	local _lang lang langs
	for lang in ${IUSE_LINGUAS}; do
		_lang=$(translate_lang ${lang})
		if use linguas_${lang} || [[ ${lang} == "en" ]]; then
			# From the CMakeLists.txt
			# "#Bit of a hack, preprocess all the filenames to generate our language string, needed for -DWANT_GUI_LANG=en_GB;de_DE , etc"
			langs+=";${_lang}"
		else
			# Don't install localized documentation
			sed -e "/${_lang}/d" -i doc/CMakeLists.txt || die
			safe_delete \
				./resources/dicts/README_${_lang}.txt \
				./resources/dicts/README_hyph_${_lang}.txt \
				./resources/dicts/hyph_${_lang}.dic \
				./resources/loremipsum/${_lang}.xml
		fi
		sed -e "/en_EN/d" -i doc/CMakeLists.txt || die
		safe_delete \
			./resources/dicts/README_en_EN.txt \
			./resources/dicts/README_hyph_en_EN.txt \
			./resources/dicts/hyph_en_EN.dic \
			./resources/loremipsum/en_EN.xml
	done

	local mycmakeargs=(
		-DHAVE_PYTHON=ON
		-DPYTHON_INCLUDE_PATH="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DWANT_DISTROBUILD=ON
		-DDOCDIR="/usr/share/doc/${PF}/"
		-DWANT_GUI_LANG="${langs#;};en"
		$(cmake-utils_use_with pdf PODOFO)
		$(cmake-utils_use_with boost)
		$(cmake-utils_use_want graphicsmagick)
		$(cmake-utils_use !osg WANT_NOOSG)
		$(cmake-utils_use_want debug DEBUG)
		$(cmake-utils_use_want minimal NOHEADERINSTALL)
		$(cmake-utils_use_want hunspell HUNSPELL)
		$(cmake-utils_use_want !examples NOEXAMPLES)
		$(cmake-utils_use_want !templates NOTEMPLATES)
		)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	local lang _lang
	# en_EN can be deleted always
	for lang in ${IUSE_LINGUAS}; do
		if ! use linguas_${lang}; then
			_lang=$(translate_lang)
			safe_delete "${ED}"/usr/share/man/${_lang}
		fi
	done

	if ! use scripts; then
		rm "${ED}"/usr/share/scribus/scripts/*.py || die
	elif ! use tk; then
		rm "${ED}"/usr/share/scribus/scripts/{FontSample,CalendarWizard}.py || die
	fi

	use scripts && \
		python_fix_shebang "${ED}"/usr/share/scribus/scripts && \
		python_optimize "${ED}"/usr/share/scribus/scripts

	mv "${ED}"/usr/share/doc/${PF}/{en,html} || die
	ln -sf html "${ED}"/usr/share/doc/${PF}/en || die
	cat >> "${T}"/COPYING <<- EOF
	${PN} is licensed under the "${LICENSE}".
	Please visit https://www.gnu.org/licenses/gpl-2.0.html for the complete license text.
	EOF
	dodoc "${T}"/COPYING
	docompress -x /usr/share/doc/${PF}/en /usr/share/doc/${PF}/{AUTHORS,TRANSLATION,LINKS,COPYING}
	doicon resources/icons/scribus.png
	domenu scribus.desktop
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

safe_delete () {
	local x
	for x in ${@}; do
		if [[ -d "${x}" ]]; then
			ebegin "Deleting ${x} recursively"
			rm -r "${x}" || die
			eend $?
		elif [[ -f "${x}" ]]; then
			ebegin "Deleting ${x}"
			rm "${x}" || die
			eend $?
		else
			ewarn "${x} not found"
		fi
	done
}

translate_lang() {
	_lang=${1}
	[[ ${1} == "ru_RU" ]] && _lang+=_0
	[[ ${1} == "de@1901" ]] && _lang=de_1901
	echo ${_lang}
}
