# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk?"
CMAKE_MAKEFILE_GENERATOR=ninja
COMMIT=1ed85778dd55bcbcfad2bbc276fd4c97f43ad965
inherit cmake-utils desktop flag-o-matic gnome2-utils python-single-r1 xdg-utils

DESCRIPTION="Desktop publishing (DTP) and layout program"
HOMEPAGE="https://www.scribus.net/"
SRC_URI="https://github.com/${PN}project/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="+boost debug examples graphicsmagick hunspell +minimal osg +pdf scripts templates tk"

#a=$((ls resources/translations/scribus.*ts | sed -e 's:\.: :g' | awk '{print $2}'; ls resources/loremipsum/*xml | sed -e 's:\.: :g' -e 's:loremipsum\/: :g'| awk '{print $2}'; ls resources/dicts/hyph*dic | sed -e 's:\.: :g' -e 's:hyph_: :g' | awk '{print $2}'; ls resources/dicts/README_*txt | sed -e 's:_hyph::g' -e 's:\.: :g' -e 's:README_: :g' | awk '{print $2}') | sort | uniq); echo $a
# Keep this sorted, otherwise eliminating of duplicates below won't work
IUSE_L10N=" af ar bg br ca ca_ES cs cs_CZ cy cy_GB da da_DK de de_1901 de_CH de_DE el en_AU en_GB en_US eo es es_ES et eu fa_IR fi fi_FI fr gl he he_IL hr hu hu_HU ia id id_ID is is_IS it ja kab kn_IN ko ku la lt lt_LT nb_NO nl nn_NO pl pl_PL pt pt_BR pt_PT ro ro_RO ru ru_RU_0 sa sk sk_SK sl sl_SI so sq sr sv sv_SE te th_TH tr uk uk_UA zh_CN zh_TW"

map_lang() {
	local lang=${1/_/-}
	case $1 in
		# Retain the following, which have a specific subtag
		de_*|en_*|pt_*|zh_*) ;;
		# Consider all other xx_XX as duplicates of the generic xx tag
		*_*) lang=${1%%_*} ;;
	esac
	echo ${lang}
}

prev_l=
for l in ${IUSE_L10N}; do
	l=$(map_lang ${l})
	[[ ${l} != "${prev_l}" ]] && IUSE+=" l10n_${l}"
	prev_l=${l}
done
unset l prev_l

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	tk? ( scripts )"

# osg
# couple of third_party libs bundled
COMMON_DEPEND="${PYTHON_DEPS}
	app-text/libmspub
	app-text/libqxp
	app-text/poppler:=
	dev-libs/hyphen
	>=dev-libs/icu-58.2:0=
	dev-libs/librevenge
	dev-libs/libxml2
	dev-qt/qtcore:5
	dev-qt/qtgui:5[-gles2]
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/fontconfig
	media-libs/freetype:2
	>=media-libs/harfbuzz-0.9.42:0=[icu]
	media-libs/lcms:2
	media-libs/libcdr
	media-libs/libfreehand
	media-libs/libpagemaker
	media-libs/libpng:0=
	media-libs/libvisio
	media-libs/libzmf
	media-libs/tiff:0
	net-print/cups
	sys-libs/zlib[minizip]
	virtual/jpeg:0=
	>=x11-libs/cairo-1.10.0[X,svg]
	boost? ( >=dev-libs/boost-1.62:= )
	hunspell? ( app-text/hunspell:= )
	graphicsmagick? ( media-gfx/graphicsmagick:= )
	osg? ( dev-games/openscenegraph:= )
	pdf? ( app-text/podofo:0= )
	scripts? ( dev-python/pillow[tk?,${PYTHON_USEDEP}] )
"
RDEPEND="${COMMON_DEPEND}
	app-text/ghostscript-gpl
"
DEPEND="${COMMON_DEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.3-docdir.patch
	"${FILESDIR}"/${PN}-1.5.3-fpic.patch
)

S="${WORKDIR}"/${PN}-${COMMIT}

src_prepare() {
	rm -r codegen/cheetah || die
	cat > cmake/modules/FindZLIB.cmake <<- EOF || die
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

	sed \
		-e "/^add_subdirectory(ui\/qml)/s/^/#DONT/" \
		-i scribus/CMakeLists.txt || die # nothing but a bogus Hello World test

	cmake-utils_src_prepare
}

src_configure() {
	# bug #550818
	append-cppflags -DHAVE_MEMRCHR

	local _lang lang langs
	for _lang in ${IUSE_L10N}; do
		lang=$(map_lang ${_lang})
		if use l10n_${lang}; then
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
		-DDOCDIR="${EPREFIX%/}/usr/share/doc/${PF}/"
		-DWANT_GUI_LANG="${langs#;};en"
		-DWITH_PODOFO="$(usex pdf)"
		-DWITH_BOOST="$(usex boost)"
		-DWANT_GRAPHICSMAGICK="$(usex graphicsmagick)"
		-DWANT_NOOSG="$(usex !osg)"
		-DWANT_DEBUG="$(usex debug)"
		-DWANT_HEADERINSTALL="$(usex !minimal)"
		-DWANT_HUNSPELL="$(usex hunspell)"
		-DWANT_NOEXAMPLES="$(usex !examples)"
		-DWANT_NOTEMPLATES="$(usex !templates)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	local lang _lang
	# en_EN can be deleted always
	for _lang in ${IUSE_L10N}; do
		lang=$(map_lang ${_lang})
		if ! use l10n_${lang}; then
			safe_delete "${ED%/}"/usr/share/man/${_lang}
		fi
	done

	if ! use scripts; then
		rm "${ED%/}"/usr/share/scribus/scripts/*.py || die
	elif ! use tk; then
		rm "${ED%/}"/usr/share/scribus/scripts/{FontSample,CalendarWizard}.py || die
	fi

	use scripts && \
		python_fix_shebang "${ED%/}"/usr/share/scribus/scripts && \
		python_optimize "${ED%/}"/usr/share/scribus/scripts

	mv "${ED%/}"/usr/share/doc/${PF}/{en,html} || die
	ln -sf html "${ED%/}"/usr/share/doc/${PF}/en || die
	cat >> "${T}"/COPYING <<- EOF || die
	${PN} is licensed under the "${LICENSE}".
	Please visit https://www.gnu.org/licenses/gpl-2.0.html for the complete license text.
	EOF
	dodoc "${T}"/COPYING
	docompress -x /usr/share/doc/${PF}/en /usr/share/doc/${PF}/{AUTHORS,TRANSLATION,LINKS,COPYING}
	local size
	for size in 16 32 128 256; do
		newicon -s $size resources/iconsets/artwork/icon_${size}x${size}.png scribus.png
	done
	newicon -s 64 resources/iconsets/artwork/icon_32x32@2x.png scribus.png
	doicon resources/iconsets/*/scribus.png
	domenu scribus.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
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
		fi
	done
}
