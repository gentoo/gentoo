# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

WX_GTK_VER="3.0"

inherit cmake-utils eutils flag-o-matic gnome2-utils python-single-r1 wxwidgets vcs-snapshot versionator xdg

DESCRIPTION="Electronic Schematic and PCB design tools."
HOMEPAGE="http://www.kicad-pcb.org"

SERIES=$(get_version_component_range 1-2)

SRC_URI="https://launchpad.net/${PN}/${SERIES}/${PV}/+download/${P}.tar.xz
	!minimal? (
		http://downloads.kicad-pcb.org/libraries/${PN}-footprints-${PV}.tar.gz
		http://downloads.kicad-pcb.org/libraries/kicad-library-${PV}.tar.gz
	)
	i18n? ( https://github.com/KiCad/${PN}-i18n/archive/${PV}.tar.gz -> ${P}-i18n.tar.gz )"

LICENSE="GPL-2+ GPL-3+ Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples github i18n libressl minimal +python"
LANGS="bg ca cs de el es fi fr hu it ja ko nl pl pt ru sk sl sv zh-CN"
for lang in ${LANGS} ; do
	IUSE="${IUSE} l10n_${lang}"
done
unset lang

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND=">=x11-libs/wxGTK-3.0.2:${WX_GTK_VER}[X,opengl]
	python? (
		dev-python/wxpython:${WX_GTK_VER}[opengl,${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)
	>=dev-libs/boost-1.61[context,nls,threads,python?,${PYTHON_USEDEP}]
	github? (
		libressl? ( dev-libs/libressl:0= )
		!libressl? ( dev-libs/openssl:0= )
	)
	media-libs/glew:0=
	media-libs/freeglut
	media-libs/mesa
	sys-libs/zlib
	x11-libs/cairo"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
	i18n? ( virtual/libintl )
	python? ( dev-lang/swig:0 )"
RDEPEND="${COMMON_DEPEND}
	sci-electronics/electronics-menu"

pkg_setup() {
	use python && python-single-r1_pkg_setup
	setup-wxwidgets
}

src_prepare() {
	xdg_src_prepare

	# Patch to work with >=boost 1.61
	eapply "${FILESDIR}/${PN}-boost-1.61.patch"

	# remove all the non unix file endings
	while IFS="" read -d $'\0' -r f; do
		edos2unix "${f}"
	done < <(find "${S}" -type f -name "*.desktop" -print0)

	# Remove cvpcb desktop file while it does nothing
	rm "${WORKDIR}/${P}/resources/linux/mime/applications/cvpcb.desktop" || die

	# Handle optional minimal install.
	if use minimal; then
		# remove templates as they are not needed to run binaries
		sed -e '/add_subdirectory( template )/d' -i CMakeLists.txt || die
	else
		# create a link to the parts library in the main project folder
		ln -s "${WORKDIR}/kicad-library-${PV}" "${S}/${PN}-library" || die
		# create a link to the footprints library and add cmake build rule for it
		ln -s "${WORKDIR}/${PN}-footprints-${PV}" "${S}/${PN}-footprints" || die
		cp "${FILESDIR}/${PN}-footprints-cmakelists.txt" "${WORKDIR}/${PN}-footprints-${PV}/CMakeLists.txt" || die
		# add the libraries directory to cmake as a subproject to build
		sed "/add_subdirectory( bitmaps_png )/a add_subdirectory( ${PN}-library )" -i CMakeLists.txt || die
		# add the footprints directory to cmake as a subproject to build
		sed "/add_subdirectory( ${PN}-library )/a add_subdirectory( ${PN}-footprints )" -i CMakeLists.txt || die
		# remove duplicate uninstall directions for the library module
		sed '/make uninstall/,/# /d' -i ${PN}-library/CMakeLists.txt || die
	fi

	# Add internationalization for the GUI
	if use i18n; then
		# create a link to the translations library in the main project folder
		ln -s "${WORKDIR}/${P}-i18n" "${S}/${PN}-i18n" || die
		# Remove unused languages. Project generates only languages specified in the
		# file in LINGUAS in the subproject folder. By default all languages are added
		# so we sed out the unused ones based on the user l10n_* settings.
		local lang
		for lang in ${LANGS}; do
			if ! use l10n_${lang}; then
				lang="${lang//-/_}"  # Needed to turn zh-CN to zh_CN as KiCad does not follow l10n standard here
				sed "/${lang}/d" -i ${PN}-i18n/LINGUAS || die
			fi
		done
		# cmakelists does not respect our build dir variables, so make it point to the right location
		sed "s|\${CMAKE_BINARY_DIR}|${WORKDIR}/${P}_build|g" -i ${PN}-i18n/CMakeLists.txt || die
		# we also make from the master project so the source dir is understood incorretly, replace that too
		sed "s|\${CMAKE_SOURCE_DIR}/\${LANG}|\${CMAKE_SOURCE_DIR}/${PN}-i18n/\${LANG}|g" -i ${PN}-i18n/CMakeLists.txt || die
		# add the translations directory to cmake as a subproject to build
		sed "/add_subdirectory( bitmaps_png )/a add_subdirectory( ${PN}-i18n )" -i CMakeLists.txt || die
		# remove duplicate uninstall directions for the translation module
		sed '/make uninstall/,$d' -i ${PN}-i18n/CMakeLists.txt || die
	fi

	# Install examples if requested
	use examples || sed -e '/add_subdirectory( demos )/d' -i CMakeLists.txt || die

	# Add important missing doc files
	sed -e 's/INSTALL.txt/AUTHORS.txt CHANGELOG.txt README.txt TODO.txt/' -i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DPYTHON_DEST="$(python_get_sitedir)"
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DKICAD_DOCS="/usr/share/doc/${PF}"
		-DKICAD_HELP="/usr/share/doc/${PF}/help"
		-DwxUSE_UNICODE=ON
		-DKICAD_SKIP_BOOST=ON
		-DBUILD_GITHUB_PLUGIN="$(usex github)"
		-DKICAD_SCRIPTING="$(usex python)"
		-DKICAD_SCRIPTING_MODULES="$(usex python)"
		-DKICAD_SCRIPTING_WXPYTHON="$(usex python)"
		-DKICAD_I18N_UNIX_STRICT_PATH="$(usex i18n)"
		-DCMAKE_CXX_FLAGS="-std=c++11"
	)
	if use debug; then
		append-cxxflags "-DDEBUG"
		append-cflags "-DDEBUG"
	fi
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		doxygen Doxyfile || die
	fi
}

src_install() {
	cmake-utils_src_install
	use python && python_optimize
	if use doc ; then
		dodoc uncrustify.cfg
		cd Documentation || die
		dodoc -r GUI_Translation_HOWTO.pdf guidelines/UIpolicies.txt doxygen/.
	fi
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update

	if use minimal ; then
		ewarn "If the schematic and/or board editors complain about missing libraries when you"
		ewarn "open old projects, you will have to take one or more of the following actions :"
		ewarn "- Install the missing libraries manually."
		ewarn "- Remove the libraries from the 'Libs and Dir' preferences."
		ewarn "- Fix the libraries' locations in the 'Libs and Dir' preferences."
		ewarn "- Emerge ${PN} without the 'minimal' USE flag."
	fi
	elog ""
	elog "You may want to emerge media-gfx/wings if you want to create 3D models of components."
	elog "For help and extended documentation emerge app-doc/kicad-doc."
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
