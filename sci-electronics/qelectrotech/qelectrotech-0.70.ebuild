# Copyright 2001-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg

DESCRIPTION="Qt5 application to design electric diagrams"
HOMEPAGE="https://qelectrotech.org/"

if [[ ${PV} = *9999* ]]; then
	inherit subversion
	ESVN_REPO_URI="svn://svn.tuxfamily.org/svnroot/qet/qet/trunk"
else
	MY_P=qet-${PV/%0/.0}
	SRC_URI="https://git.tuxfamily.org/qet/qet.git/snapshot/${MY_P}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}"/${MY_P}
fi

LICENSE="CC-BY-3.0 GPL-2+"
SLOT="0"
IUSE="doc"

BDEPEND="
	doc? ( app-doc/doxygen )
"
RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/kwidgetsaddons:5
"
DEPEND="${RDEPEND}"

DOCS=( CREDIT ChangeLog README )

PATCHES=( "${FILESDIR}/${PN}-0.3-fix-paths.patch" )

src_configure() {
	eqmake5 ${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	if use doc; then
		doxygen Doxyfile || die
		local HTML_DOCS=( doc/html/. )
	fi

	einstalldocs
}
