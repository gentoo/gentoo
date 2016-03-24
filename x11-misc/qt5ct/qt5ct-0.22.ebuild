# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qt5-build


DESCRIPTION="This program allows users to configure Qt5 settings"
HOMEPAGE="http://qt5ct.sourceforge.net/"
SRC_URI="mirror://sourceforge/qt5ct/${P}.tar.bz2"
S="${WORKDIR}/${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
DEPEND=">=dev-qt/qtcore-5.4.2
	>=dev-qt/qtxml-5.4.2
        >=dev-qt/linguist-tools-5.4.2
        >=dev-qt/qtgui-5.4.2
        >=dev-qt/qtwidgets-5.4.2"

RDEPEND=">=dev-qt/qtcore-5.4.2
	>=dev-qt/qtxml-5.4.2
        >=dev-qt/qtgui-5.4.2
        >=dev-qt/qtwidgets-5.4.2"

src_unpack() {
    qt5-build_src_unpack
}
src_prepare() {
    qt5-build_src_prepare

}
src_configure() {
    qt5-build_src_configure
}
src_install() {
    qt5-build_src_install
}
