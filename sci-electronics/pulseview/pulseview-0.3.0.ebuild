# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_4 )

inherit cmake-utils python-single-r1

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-r3
else
	SRC_URI="http://sigrok.org/download/source/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Qt based logic analyzer GUI for sigrok"
HOMEPAGE="http://sigrok.org/wiki/PulseView"

LICENSE="GPL-3"
SLOT="0"
IUSE="+decode qt4 qt5 static"
REQUIRED_USE="decode? ( ${PYTHON_REQUIRED_USE} ) ^^ ( qt4 qt5 )"

RDEPEND="
	>=dev-libs/boost-1.53:=
	>=dev-libs/glib-2.28.0:2
	>=dev-cpp/glibmm-2.28.0:2
	>=sci-libs/libsigrok-0.4.0[cxx]
	qt4? (
		>=dev-qt/qtcore-4.5:4
		>=dev-qt/qtgui-4.5:4
		>=dev-qt/qtsvg-4.5:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtsvg:5
	)
	decode? (
		>=sci-libs/libsigrokdecode-0.4.0[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( HACKING NEWS README )

src_configure() {
	local mycmakeargs=(
		-DDISABLE_WERROR=TRUE
		-DENABLE_DECODE=$(usex decode)
		-DSTATIC_PKGDEPS_LIBS=$(usex static)
		-DFORCE_QT4=$(usex qt4)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newicon "${S}"/icons/sigrok-logo-notext.png ${PN}.png
	domenu "${FILESDIR}"/${PN}.desktop
}
