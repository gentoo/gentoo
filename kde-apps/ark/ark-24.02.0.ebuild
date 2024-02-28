# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
ECM_TEST="optional"
KFMIN=6.0
QTMIN=6.6.2
inherit ecm gear.kde.org optfeature

DESCRIPTION="File archiver by KDE"
HOMEPAGE="https://apps.kde.org/ark/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64"
IUSE="zip"

RDEPEND="
	>=app-arch/libarchive-3.5.3:=[bzip2,lzma]
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/kdbusaddons-${KFMIN}:6
	>=kde-frameworks/kfilemetadata-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kpty-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	sys-libs/zlib
	zip? ( >=dev-libs/libzip-1.6.0:= )
"
DEPEND="${RDEPEND}
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[concurrent]
	test? ( >=dev-libs/libzip-1.6.0:= )
"
# app-arch/rar is binary only
BDEPEND="
	sys-devel/gettext
	elibc_glibc? ( test? ( amd64? ( app-arch/rar ) x86? ( app-arch/rar ) ) )
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package zip LibZip)
	)

	ecm_src_configure
}

src_test() {
	local myctestargs=(
		# bug 822177: kerfuffle-addtoarchivetest: may segfault or hang indefinitely
		# bug 827840: plugins-clirartest: continuously broken with translations installed
		-E "(kerfuffle-addtoarchivetest|plugins-clirartest)"
	)

	ecm_src_test
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "rar archive creation/extraction" "app-arch/rar"
		optfeature "rar archive extraction only" "app-arch/unar" "app-arch/unrar"
		optfeature "7-Zip archive support" "app-arch/p7zip"
		optfeature "lrz archive support" "app-arch/lrzip"
		optfeature "Markdown support in text previews" "kde-misc/markdownpart:${SLOT}"
	fi
	ecm_pkg_postinst
}
