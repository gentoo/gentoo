# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit bash-completion-r1 cmake kde.org python-single-r1

DESCRIPTION="A framework for custom processing of PO files"
HOMEPAGE="http://pology.nedohodnik.net"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="http://pology.nedohodnik.net/release/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.5
"
RDEPEND="${PYTHON_DEPS}
	dev-libs/libxml2
	dev-libs/libxslt
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_MULTI_USEDEP}]
	')
	sys-devel/gettext
"
DEPEND="${RDEPEND}"

# Magic on python parsing makes it impossible to make it parallel safe
MAKEOPTS+=" -j1"

src_prepare() {
	cmake_src_prepare
	sed -e "/DOC_INSTALL_DIR/s/^/#DONT/" -i CMakeLists.txt || die
	python_fix_shebang .
}

src_configure() {
	local mycmakeargs=(
		-DDOC_INSTALL_DIR="${EPREFIX}"/usr/share/doc/${PF}
		-DCMAKE_DISABLE_FIND_PACKAGE_Epydoc=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Pygments=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_optimize

	dosym ../../../pology/syntax/kate/synder.xml /usr/share/apps/katepart/syntax/synder.xml

	newbashcomp "${ED}"/usr/share/pology/completion/bash/pology posieve
	bashcomp_alias {posieve,poediff}{,.py}

	elog "You should also consider following packages to install:"
	elog "    app-text/aspell"
	elog "    app-text/hunspell"
	elog "    dev-vcs/git"
	elog "    dev-vcs/subversion"
	elog "    sci-misc/apertium"
}
