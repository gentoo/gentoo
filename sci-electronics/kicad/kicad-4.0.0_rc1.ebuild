# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

WX_GTK_VER="3.0"

inherit cmake-utils fdo-mime flag-o-matic gnome2-utils python-single-r1 python-utils-r1 vcs-snapshot wxwidgets versionator

DESCRIPTION="Electronic Schematic and PCB design tools."
HOMEPAGE="http://www.kicad-pcb.org"

SERIES=$(get_version_component_range 1-2)
MY_PV=$(replace_version_separator 3 '-')

LIB_REVISION="bd0ec6a20c7cc0556093f60eac723e4505947784"
DOC_REVISION="0d0ed7b9de3afbba5d51fb6d7a25834000ed1099"
I18N_REVISION="bf793d30d64f4e75ea7a109ea434c1a27926b158"

SRC_URI="https://launchpad.net/${PN}/${SERIES}/${MY_PV}/+download/${PN}-${MY_PV}.tar.xz
	!minimal? ( https://github.com/KiCad/${PN}-library/tarball/${LIB_REVISION} -> ${P}-library.tar.gz )
	i18n? ( https://github.com/KiCad/${PN}-i18n/tarball/${I18N_REVISION} -> ${P}-i18n.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples github i18n minimal python webkit"
LANGS="bg ca cs de el es fi fr hu it ja ko nl pl pt ru sk sl sv zh_CN"
for lang in ${LANGS} ; do
	IUSE="${IUSE} linguas_${lang}"
done
unset lang

REQUIRED_USE="
	github? ( webkit )
	python? ( ${PYTHON_REQUIRED_USE} )"

CDEPEND="x11-libs/wxGTK:${WX_GTK_VER}[X,opengl,webkit?]
	python? (
		dev-python/wxpython:${WX_GTK_VER}[opengl,${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)
	>=dev-libs/boost-1.56[context,threads,python?]
	github? ( dev-libs/openssl:0 )
	media-libs/glew
	media-libs/freeglut
	media-libs/mesa
	sys-libs/zlib
	x11-libs/cairo"
DEPEND="${CDEPEND}
	app-arch/xz-utils
	doc? ( app-doc/doxygen )
	i18n? ( >=sys-devel/gettext-0.18 )
	python? ( dev-lang/swig:0 )"
RDEPEND="${CDEPEND}
	sci-electronics/electronics-menu"

S="${WORKDIR}/${PN}-${MY_PV}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	if use python; then
		# dev-python/wxpython doesn't support python3
		sed '/set(_PYTHON3_VERSIONS 3.3 3.2 3.1 3.0)/d' -i CMakeModules/FindPythonLibs.cmake || die "sed failed"
	fi

	# Handle optional minimal install.
	if use minimal; then
		# remove tempaltes as they are not needed to run binaries
		sed -e '/add_subdirectory( template )/d' -i CMakeLists.txt || die "sed failed"
	else
		# create a link to the parts library in the main project folder
		ln -s "${WORKDIR}/${P}-library" "${S}/${PN}-library" || die "ln failed"
		# add the libraries directory to cmake as a subproject to build
		sed "/add_subdirectory( bitmaps_png )/a add_subdirectory( ${PN}-library )" -i CMakeLists.txt || die "sed failed"
		# add the libraries directory subproject also to uninstallation procedures
		sed '/make uninstall/,/# /d' -i ${PN}-library/CMakeLists.txt || die "sed failed"
	fi

	# Add internationalization for the GUI
	if use i18n; then
		# create a link to the translations library in the main project folder
		ln -s "${WORKDIR}/${P}-i18n" "${S}/${PN}-i18n" || die "ln failed"
		# Remove unused languages. Project generates only languages specified in the
		# file in LINGUAS in the subproject folder. By default all languages are added
		# so we sed out the unused ones based on the user linguas_* settings.
		local lang=""
		for lang in ${LANGS}; do
			if ! use linguas_${lang}; then
				sed "/${lang}/d" -i ${PN}-i18n/LINGUAS || die "sed failed"
			fi
		done
		# cmakelists does not respect our build dir variables, so make it point to the right location
		sed "s|\${CMAKE_BINARY_DIR}|${WORKDIR}/${P}_build|g" -i ${PN}-i18n/CMakeLists.txt || die "sed failed"
		# we also make from the master project so the source dir is understood incorretly, replace that too 
		sed "s|\${CMAKE_SOURCE_DIR}/\${LANG}|\${CMAKE_SOURCE_DIR}/${PN}-i18n/\${LANG}|g" -i ${PN}-i18n/CMakeLists.txt || die "sed failed"
		# add the translations directory to cmake as a subproject to build
		sed "/add_subdirectory( bitmaps_png )/a add_subdirectory( ${PN}-i18n )" -i CMakeLists.txt || die "sed failed"
		# add the translations directory subproject also to uninstallation procedures
		sed '/make uninstall/,$d' -i ${PN}-i18n/CMakeLists.txt || die "sed failed"
	fi

	# Install examples in the right place if requested
	if use examples; then
		sed -e 's:${KICAD_DATA}/demos:${KICAD_DOCS}/examples:' -i CMakeLists.txt || die "sed failed"
	else
		sed -e '/add_subdirectory( demos )/d' -i CMakeLists.txt || die "sed failed"
	fi

	# Add important missing doc files
	sed -e 's/INSTALL.txt/AUTHORS.txt CHANGELOG.txt README.txt TODO.txt/' -i CMakeLists.txt || die "sed failed"
}

src_configure() {
	need-wxwidgets unicode

	local mycmakeargs=(
		-DKICAD_DOCS="/usr/share/doc/${PF}"
		-DKICAD_HELP="/usr/share/doc/${PF}/help"
		-DwxUSE_UNICODE=ON
		-DKICAD_SKIP_BOOST=ON
		$(cmake-utils_use github BUILD_GITHUB_PLUGIN)
		$(cmake-utils_use python KICAD_SCRIPTING)
		$(cmake-utils_use python KICAD_SCRIPTING_MODULES)
		$(cmake-utils_use python KICAD_SCRIPTING_WXPYTHON)
		$(cmake-utils_use webkit KICAD_USE_WEBKIT)
		$(usex i18n "-DKICAD_I18N_UNIX_STRICT_PATH=1" "")
	)
	if use debug; then
		append-flags "-DDEBUG"
	fi
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc; then
		doxygen Doxyfile || die "doxygen failed"
	fi
}

src_install() {
	cmake-utils_src_install
	use python && python_optimize "${D}/usr/$(get_libdir)/${EPYTHON}/site-packages/pcbnew.py"
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins uncrustify.cfg
		cd Documentation || die "cd failed"
		doins -r GUI_Translation_HOWTO.pdf guidelines/UIpolicies.txt doxygen/*
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update

	if use minimal ; then
		ewarn "If the schematic and/or board editors complain about missing libraries when you"
		ewarn "open old projects, you will have to take one or more of the following actions :"
		ewarn "- Install the missing libraries manually."
		ewarn "- Remove the libraries from the 'Libs and Dir' preferences."
		ewarn "- Fix the libraries' locations in the 'Libs and Dir' preferences."
		ewarn "- Emerge ${PN} without the 'minimal' USE flag."
		ewarn ""
	fi
	elog "You may want to emerge media-gfx/wings if you want to create 3D models of components."
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
