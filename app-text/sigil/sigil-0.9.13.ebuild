# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit cmake-utils python-single-r1 readme.gentoo-r1 xdg-utils

MY_P="Sigil-${PV}"

DESCRIPTION="Sigil is a multi-platform WYSIWYG ebook editor for ePub format"
HOMEPAGE="https://sigil-ebook.com/"
SRC_URI="https://github.com/Sigil-Ebook/Sigil/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3+ Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-text/hunspell:=
	dev-libs/boost:=[threads]
	dev-libs/libpcre:3=[pcre16]
	dev-libs/mathjax
	dev-libs/xerces-c[icu]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/cssselect[${PYTHON_USEDEP}]
	dev-python/cssutils[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-qt/qtconcurrent-5.4:5
	>=dev-qt/qtcore-5.4:5
	>=dev-qt/qtgui-5.4:5
	>=dev-qt/qtprintsupport-5.4:5
	>=dev-qt/qtwebkit-5.4:5
	>=dev-qt/qtwidgets-5.4:5
	>=dev-qt/qtxmlpatterns-5.4:5
	sys-libs/zlib[minizip]
"
DEPEND="${RDEPEND}"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

DOCS=( ChangeLog.txt README.md )

DOC_CONTENTS="From Sigil's release notes:
When you fire up Sigil for the very first time:
navigate to the new General Preferences and select the default
epub version you plan to work with (epub 2 or epub3) so that new
empty ebooks start with the correct code.
if you plan to work with epub3 epubs, you should change your
PreserveEntities setting to use ONLY NUMERIC entities.

For example use & # 1 6 0 ; for non-breaking spaces and etc.

We strongly recommend enabling Mend On Open in your settings
for best performance with Sigil."

src_configure() {
	python_export PYTHON_LIBPATH PYTHON_INCLUDEDIR
	local mycmakeargs=(
		-DINSTALL_BUNDLED_DICTS=0
		-DMATHJAX_DIR="${EPREFIX}"/usr/share/mathjax
		-DUSE_SYSTEM_LIBS=1
		-DSYSTEM_LIBS_REQUIRED=1
		-DPYTHON_EXECUTABLE="${PYTHON}"
		-DPYTHON_LIBRARY="${PYTHON_LIBPATH}"
		-DPYTHON_INCLUDE_DIR="${PYTHON_INCLUDEDIR}"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	python_fix_shebang "${ED}"/usr/share/sigil/
	python_optimize "${ED}"/usr/share/sigil/
	DISABLE_AUTOFORMATTING=true readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_desktop_database_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	xdg_desktop_database_update
}
