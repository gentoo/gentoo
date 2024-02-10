# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ecm

DESCRIPTION="Frontend to various audio converters"
HOMEPAGE="https://www.linux-apps.com/p/1126634/ https://github.com/dfaust/soundkonverter"
SRC_URI="https://github.com/dfaust/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/src"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	kde-apps/libkcddb:5
	kde-frameworks/kcompletion:5
	kde-frameworks/kconfig:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/kcoreaddons:5
	kde-frameworks/kdelibs4support:5
	kde-frameworks/ki18n:5
	kde-frameworks/kio:5
	kde-frameworks/knotifications:5
	kde-frameworks/kservice:5
	kde-frameworks/ktextwidgets:5
	kde-frameworks/kwidgetsaddons:5
	kde-frameworks/kxmlgui:5
	kde-frameworks/solid:5
	>=media-libs/phonon-4.11.0[qt5(+)]
	>=media-libs/taglib-1.10
	media-sound/cdparanoia
"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

# git master, now archived:
PATCHES=(
	"${FILESDIR}/${P}-deps.patch"
	"${FILESDIR}/${P}-kf-5.72-findtaglib.patch"
	"${FILESDIR}/${P}-fix-add-dirs.patch"
	"${FILESDIR}/${P}-metainfodir.patch"
)

pkg_postinst() {
	ecm_pkg_postinst

	elog "soundKonverter optionally supports many different audio formats."
	elog "You will need to install the appropriate encoding packages for the"
	elog "formats you require. For a full listing, consult the README file"
	elog "in /usr/share/doc/${PF}"
}
