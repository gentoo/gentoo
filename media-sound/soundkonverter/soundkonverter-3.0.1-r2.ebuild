# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm

DESCRIPTION="Frontend to various audio converters"
HOMEPAGE="https://www.linux-apps.com/p/1126634/ https://github.com/dfaust/soundkonverter"
SRC_URI="https://github.com/dfaust/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	sys-devel/gettext
"
DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-apps/libkcddb-19.04.3:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdelibs4support-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/solid-${KFMIN}:5
	media-libs/phonon[qt5(+)]
	>=media-libs/taglib-1.10
	media-sound/cdparanoia
"
RDEPEND="${DEPEND}
	!media-sound/soundkonverter:4
"

PATCHES=(
	"${FILESDIR}/${P}-deps.patch" # pending upstream
	"${FILESDIR}/${P}-kf-5.72-findtaglib.patch" # pending upstream
	"${FILESDIR}/${P}-fix-add-dirs.patch"
	"${FILESDIR}/${P}-metainfodir.patch"
)

S="${WORKDIR}"/${P}/src

pkg_postinst() {
	ecm_pkg_postinst

	elog "soundKonverter optionally supports many different audio formats."
	elog "You will need to install the appropriate encoding packages for the"
	elog "formats you require. For a full listing, consult the README file"
	elog "in /usr/share/doc/${PF}"
}
