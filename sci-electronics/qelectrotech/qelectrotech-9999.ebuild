# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PLOCALES="cs de el en es fr it pl pt ro ru"

inherit l10n qt4-r2 subversion

DESCRIPTION="Qt4 application to design electric diagrams"
HOMEPAGE="http://qelectrotech.org/"
ESVN_REPO_URI="svn://svn.tuxfamily.org/svnroot/qet/qet/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

IUSE="doc"

RDEPEND="
	dev-qt/designer:4
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsql:4[sqlite]
	dev-qt/qtsvg:4
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
"

DOCS=(CREDIT ChangeLog README)
PATCHES=(
	"${FILESDIR}/${PN}-0.3-fix-paths.patch"
)

qet_disable_translation() {
	sed -i -e "/TRANSLATIONS +=/s: lang/qet_${1}.ts::" ${PN}.pro || die
}

src_prepare() {
	qt4-r2_src_prepare
	l10n_for_each_disabled_locale_do qet_disable_translation
}

src_install() {
	qt4-r2_src_install

	if use doc; then
		doxygen Doxyfile || die
		dodoc -r doc/html
	fi
}
