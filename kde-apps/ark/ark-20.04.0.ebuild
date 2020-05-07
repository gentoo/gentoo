# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="optional"
KFMIN=5.69.0
QTMIN=5.12.3
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

DESCRIPTION="KDE Archiving tool"
HOMEPAGE="https://kde.org/applications/utilities/org.kde.ark
https://utils.kde.org/projects/ark/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="bzip2 lzma zip"

BDEPEND="
	sys-devel/gettext
"
RDEPEND="
	app-arch/libarchive:=[bzip2?,lzma?,zlib]
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemmodels-${KFMIN}:5
	>=kde-frameworks/kjobwidgets-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/kpty-${KFMIN}:5
	>=kde-frameworks/kservice-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	sys-libs/zlib
	zip? ( >=dev-libs/libzip-1.2.0:= )
"
DEPEND="${RDEPEND}
	>=dev-qt/qtconcurrent-${QTMIN}:5
"

# bug #560548, last checked with 16.04.1
RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package bzip2 BZip2)
		$(cmake_use_find_package lzma LibLZMA)
		$(cmake_use_find_package zip LibZip)
	)

	ecm_src_configure
}

pkg_postinst() {
	ecm_pkg_postinst

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		if ! has_version app-arch/rar; then
			elog "For creating/extracting rar archives, installing app-arch/rar is required."
			if ! has_version app-arch/unar && ! has_version app-arch/unrar; then
				elog "Alternatively, for only extracting rar archives, install app-arch/unar (free) or app-arch/unrar (non-free)."
			fi
		fi

		has_version app-arch/p7zip || \
			elog "For handling 7-Zip archives, install app-arch/p7zip."

		has_version app-arch/lrzip || \
			elog "For handling lrz archives, install app-arch/lrzip."
	fi
}
