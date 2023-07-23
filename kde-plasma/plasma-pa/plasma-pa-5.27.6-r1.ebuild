# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm plasma.kde.org

DESCRIPTION="Plasma applet for audio volume management using PulseAudio"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	dev-libs/glib:2
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kglobalaccel-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/plasma-${KFMIN}:5
	media-libs/libcanberra
	media-libs/libpulse
"
RDEPEND="${DEPEND}
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	x11-themes/sound-theme-freedesktop
"
BDEPEND=">=kde-frameworks/kcmutils-${KFMIN}:5"

PATCHES=( # in 5.27.7:
	"${FILESDIR}/${P}-make-setGenericVolume-keep-balance.patch" # KDE-bug 435840
	"${FILESDIR}/${P}-move-volume-logic-to-VolumeSlider.patch"
)
