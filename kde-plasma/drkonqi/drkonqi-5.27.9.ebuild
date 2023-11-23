# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="forceoptional"
KFMIN=5.106.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.9
inherit ecm plasma.kde.org systemd

DESCRIPTION="Plasma crash handler, gives the user feedback if a program crashed"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${PN}-5.27.8-revert-add-sentry-support.patch.xz"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="systemd"

COMMON_DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
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
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kwindowsystem-${KFMIN}:5
	>=kde-frameworks/syntax-highlighting-${KFMIN}:5
	systemd? (
		>=dev-qt/qtnetwork-${QTMIN}:5
		>=kde-frameworks/kservice-${KFMIN}:5
		sys-apps/systemd:=
	)
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtconcurrent-${QTMIN}:5
	test? ( >=dev-qt/qtnetwork-${QTMIN}:5 )
"
RDEPEND="${COMMON_DEPEND}
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5[qml]
	|| (
		sys-devel/gdb
		dev-util/lldb
	)
"

PATCHES=( "${WORKDIR}/${PN}-5.27.8-revert-add-sentry-support.patch" ) # bug 871759

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package systemd Systemd)
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

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] && systemd_is_booted ; then
		elog "For systemd, steps are needed for integration with systemd-coredumpd."
		elog "As root, run the following:"
		elog "1. systemctl enable drkonqi-coredump-processor@.service"
		elog "2. systemctl --user enable --now --global drkonqi-coredump-launcher.socket"
	fi
}
