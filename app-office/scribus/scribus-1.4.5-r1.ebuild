# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/scribus/scribus-1.4.5-r1.ebuild,v 1.3 2015/05/29 07:51:48 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk?"

inherit cmake-utils fdo-mime python-single-r1

DESCRIPTION="Desktop publishing (DTP) and layout program"
HOMEPAGE="http://www.scribus.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="cairo debug examples hunspell +minimal +pdf scripts templates tk"

# a=$((ls resources/translations/po/scribus.*ts | sed -e 's:\.: :g' | awk '{print $2}'; ls resources/loremipsum/*xml | sed -e 's:\.: :g' -e 's:loremipsum\/: :g'| awk '{print $2}'; ls resources/dicts/hyph*dic | sed -e 's:\.: :g' -e 's:hyph_: :g' | awk '{print $2}'; ls resources/dicts/README_*txt | sed -e 's:_hyph::g' -e 's:\.: :g' -e 's:README_: :g' | awk '{print $2}') | sort | uniq); echo $a
IUSE_LINGUAS=" af ar bg br ca ca_ES cs cs_CZ cy cy_GB da da_DK de de_1901 de_CH de_DE el en en_AU en_EN en_GB en_US eo es es_ES et eu fi fi_FI fr gl he hr hu hu_HU ia id id_ID is is_IS it ja ko ku la lt lt_LT nb_NO nl nn_NO pl pl_PL pt pt_BR pt_PT ro ro_RO ru ru_RU_0 sa sk sk_SK sl sl_SI sq sr sv sv_SE th_TH tr uk uk_UA zh_CN zh_TW"
IUSE+=" ${IUSE_LINGUAS// / linguas_}"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	tk? ( scripts )"

COMMON_DEPEND="
	${PYTHON_DEPS}
	dev-libs/boost
	dev-libs/hyphen
	dev-libs/libxml2
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/lcms:2
	media-libs/libpng:0
	media-libs/tiff:0
	net-print/cups
	sys-libs/zlib[minizip]
	virtual/jpeg:0=
	cairo? ( x11-libs/cairo[X,svg] )
	!cairo? ( media-libs/libart_lgpl )
	hunspell? ( app-text/hunspell )
	pdf? ( app-text/podofo )
	scripts? ( virtual/python-imaging[tk?,${PYTHON_USEDEP}] )
	tk? ( virtual/python-imaging[tk?,${PYTHON_USEDEP}] )
"
RDEPEND="${COMMON_DEPEND}
	app-text/ghostscript-gpl"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.2-docs.patch
	"${FILESDIR}"/${PN}-1.4.0-minizip.patch
	"${FILESDIR}"/${PN}-1.4.4-ppc64-fpic.patch
	)

src_prepare() {
	cat > cmake/modules/FindZLIB.cmake <<- EOF
	find_package(PkgConfig)
	pkg_check_modules(ZLIB minizip zlib)
	SET( ZLIB_LIBRARY \${ZLIB_LIBRARIES} )
	SET( ZLIB_INCLUDE_DIR \${ZLIB_INCLUDE_DIRS} )
	MARK_AS_ADVANCED( ZLIB_LIBRARY ZLIB_INCLUDE_DIR )
	EOF

	rm scribus/{ioapi,unzip}.[ch] || die

	sed \
		-e 's:\(${CMAKE_INSTALL_PREFIX}\):./\1:g' \
		-i resources/templates/CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local lang langs
	for lang in ${IUSE_LINGUAS}; do
		if use linguas_${lang} || [[ ${lang} == "en" ]]; then
			# From the CMakeLists.txt
			# "#Bit of a hack, preprocess all the filenames to generate our language string, needed for -DWANT_GUI_LANG=en_GB;de_DE , etc"
			langs+=";${lang}"
		else
			# Don't install localized documentation
			sed -e "/${lang}/d" -i scribus/doc/CMakeLists.txt || die
			safe_delete file ./resources/dicts/README_${lang}.txt
			safe_delete file ./resources/dicts/README_hyph_${lang}.txt
			safe_delete file ./resources/dicts/hyph_${lang}.dic
			safe_delete file ./resources/loremipsum/${lang}.xml
		fi
	done

	local mycmakeargs=(
		-DHAVE_PYTHON=ON
		-DPYTHON_INCLUDE_PATH="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DWANT_NORPATH=ON
		-DWANT_QT3SUPPORT=OFF
		-DGENTOOVERSION=${PVR}
		-DWANT_GUI_LANG="${langs#;};en"
		$(cmake-utils_use_with pdf PODOFO)
		$(cmake-utils_use_want cairo)
		$(cmake-utils_use_want !cairo QTARTHUR)
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

	local lang
	for lang in ${IUSE_LINGUAS}; do
		if ! use linguas_${lang}; then
			safe_delete dir "${ED}"/usr/share/man/${lang}
		fi
	done

	if ! use scripts; then
		rm "${ED}"/usr/share/scribus/scripts/*.py || die
	elif ! use tk; then
		rm "${ED}"/usr/share/scribus/scripts/{FontSample,CalendarWizard}.py || die
	fi

	python_fix_shebang "${ED}"/usr/share/scribus/scripts
	python_optimize "${ED}"/usr/share/scribus/scripts

	mv "${ED}"/usr/share/doc/${PF}/{en,html} || die
	ln -sf html "${ED}"/usr/share/doc/${PF}/en || die
	cat >> "${T}"/COPYING <<- EOF
	${PN} is licensed under the "${LICENSE}".
	Please visit http://www.gnu.org/licenses/gpl-2.0.html for the complete license text.
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
	case $1 in
		dir)
			if [[ -d "${2}" ]]; then
				rm -r "${2}" || die
			fi
			;;
		file)
			if [[ -f "${2}" ]]; then
				rm "${2}" || die
			fi
			;;
		*)
			die "Wrong usage"
	esac
}
