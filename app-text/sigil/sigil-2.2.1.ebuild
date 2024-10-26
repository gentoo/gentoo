# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit xdg cmake python-single-r1

DOC_VERSION="2022.05.17"
DOC_FILE="Sigil_User_Guide_${DOC_VERSION}.epub"

DESCRIPTION="Multi-platform WYSIWYG ebook editor for ePub format"
HOMEPAGE="https://sigil-ebook.com/ https://github.com/Sigil-Ebook/Sigil"
SRC_URI="https://github.com/Sigil-Ebook/Sigil/archive/${PV}.tar.gz -> ${P}.tar.gz
	doc? ( https://github.com/Sigil-Ebook/sigil-user-guide/releases/download/${DOC_VERSION}/${DOC_FILE} )"
S=${WORKDIR}/${P^}

LICENSE="GPL-3+ Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc +plugins qt6"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-text/hunspell:=
	dev-libs/libpcre2:=[pcre16]
	sys-libs/zlib[minizip]
	$(python_gen_cond_dep '
		dev-python/css-parser[${PYTHON_USEDEP}]
		dev-python/dulwich[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
	')
	plugins? ( $(python_gen_cond_dep '
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/cssselect[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/regex[${PYTHON_USEDEP}]
	')
	$(python_gen_impl_dep 'tk') )
	!qt6? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtsvg:5
		dev-qt/qtwebengine:5[widgets]
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		plugins? ( $(python_gen_cond_dep '
			dev-python/PyQt5[${PYTHON_USEDEP}]
			dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
		') )
	)
	qt6? (
		dev-qt/qtbase:6[concurrent,cups,network,widgets,xml]
		dev-qt/qt5compat:6
		dev-qt/qtwebengine:6[widgets]
		dev-qt/qtsvg:6
		plugins? ( $(python_gen_cond_dep '
			dev-python/PyQt6[${PYTHON_USEDEP}]
			dev-python/PyQt6-WebEngine[${PYTHON_USEDEP}]
		') )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	!qt6? ( dev-qt/linguist-tools:5 )
	qt6? ( dev-qt/qttools:6[linguist] )
"

DOCS=( ChangeLog.txt README.md )

src_configure() {
	local mycmakeargs=(
		-DTRY_NEWER_FINDPYTHON3=1
		-DPython3_INCLUDE_DIR="$(python_get_includedir)"
		-DPython3_LIBRARY="$(python_get_library_path)"
		-DPython3_EXECUTABLE="${PYTHON}"

		-DUSE_QT5=$(usex !qt6)
		-DINSTALL_BUNDLED_DICTS=0
		-DSYSTEM_LIBS_REQUIRED=1
		-DUSE_SYSTEM_LIBS=1
	)
	# use system-mathjax && mycmakeargs+=( -DMATHJAX3_DIR="${EPREFIX}"/usr/share/mathjax )

	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_fix_shebang "${ED}"/usr/share/sigil/
	python_optimize "${ED}"/usr/share/sigil/

	if use doc; then
		dodoc "${DISTDIR}/${DOC_FILE}"
		docompress -x /usr/share/doc/${PF}/${DOC_FILE}
	fi
}
