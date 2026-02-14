# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_PYTHON_BINDINGS="off"
QTMIN=6.10.1
inherit ecm frameworks.kde.org xdg

DESCRIPTION="Framework for solving common problems such as caching, randomisation, and more"

LICENSE="LGPL-2+"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv ~x86"
IUSE="dbus"

COMMON_DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus?,icu,network]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	virtual/libudev:=
"
DEPEND="${COMMON_DEPEND}
	sys-kernel/linux-headers
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qttranslations-${QTMIN}:6
"
BDEPEND=">=dev-qt/qttools-${QTMIN}:6[linguist]"

src_configure() {
	local mycmakeargs=(
		-DKCOREADDONS_USE_QML=ON
		-DENABLE_INOTIFY=ON
		-DUSE_DBUS=$(usex dbus)
	)
	ecm_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# bug 632398
		kautosavefiletest
		# bug 647414
		kdirwatch_qfswatch_unittest
		kdirwatch_stat_unittest
		# bugs 665682
		kformattest
		# bug 770781
		kaboutdatatest
		klistopenfilesjobtest_unix
		# bug 963953
		kpluginmetadatatest
	)
	# bug 619656
	ecm_src_test -j1
}
