# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.102.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.7
inherit ecm plasma.kde.org

DESCRIPTION="Plasma crash handler, gives the user feedback if a program crashed"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${PN}-5.27.1-revert-add-sentry-support.patch.xz"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kidletime-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	>=kde-frameworks/kwallet-${KFMIN}:5
	>=kde-frameworks/kwayland-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/syntax-highlighting-${KFMIN}:5
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtconcurrent-${QTMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5[qml]
	|| (
		sys-devel/gdb
		dev-util/lldb
	)
"

PATCHES=( "${WORKDIR}/${PN}-5.27.1-revert-add-sentry-support.patch" ) # bug 871759

src_test() {
	# needs network access, bug #698510
	local myctestargs=(
		-E "(connectiontest)"
	)
	ecm_src_test
}
