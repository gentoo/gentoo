# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=6.9.0
QTMIN=6.5.0
inherit ecm xdg

COMMIT="0a575c2246556adeecbc7b41be56e6d2e7eb6a42"

DESCRIPTION="editor for the TikZ drawing language"
HOMEPAGE="https://github.com/fhackenberger/ktikz"
SRC_URI="https://github.com/fhackenberger/ktikz/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/ktikz-${COMMIT}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-text/poppler[qt6]
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets,xml]
	>=kde-frameworks/kdoctools-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/ktexteditor-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
"
RDEPEND="${DEPEND}
	dev-texlive/texlive-latexextra
	dev-texlive/texlive-pictures
"
BDEPEND="
	dev-qt/qttools:6[assistant,linguist]
	sys-devel/gettext
"

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		-DDATA_INSTALL_DIR="${EPREFIX}"/usr/share
	)
	ecm_src_configure
}
