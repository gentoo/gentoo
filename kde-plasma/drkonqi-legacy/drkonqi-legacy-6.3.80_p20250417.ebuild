# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KDE_ORG_COMMIT="8fd0ba78c76fbabae22ec81f4d9c4f8204d0df94"
KDE_ORG_NAME="drkonqi"
PYTHON_COMPAT=( python3_{11..13} )
KFMIN=6.14.0
QTMIN=6.8.1
inherit ecm plasma.kde.org python-single-r1 xdg

DESCRIPTION="Plasma crash handler, gives the user feedback if a program crashed"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="test" # bug 935362

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,network,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kidletime-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kstatusnotifieritem-${KFMIN}:6
	>=kde-frameworks/kwallet-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/syntax-highlighting-${KFMIN}:6
	>=sys-auth/polkit-qt-0.175.0[qt6(+)]
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
	test? ( >=dev-qt/qtbase-${QTMIN}:6[network] )
"
RDEPEND="${COMMON_DEPEND}
	!kde-plasma/drkonqi
	dev-libs/elfutils[utils]
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	$(python_gen_cond_dep '
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pygdbmi[${PYTHON_USEDEP}]
	')
	|| (
		>=dev-debug/gdb-12
		llvm-core/lldb
	)
"

src_configure() {
	local mycmakeargs=(
		-DWITH_PYTHON_VENDORING=OFF
		-DWITH_SYSTEMD=OFF # non-systemd snapshot before it was made required
	)
	ecm_src_configure
}

src_test() {
	# needs network access, bug #698510
	local myctestargs=(
		-E "(connectiontest)"
	)
	ecm_src_test
}
