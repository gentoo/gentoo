# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_TEST="true"
KFMIN=6.19.0
QTMIN=6.9.1
inherit ecm flag-o-matic kde.org xdg

DESCRIPTION="Markdown editor with a wide range of formating options for everyday notes"
HOMEPAGE="https://apps.kde.org/marknote/"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

# TODO: md4c not packaged
DEPEND="
	>=dev-libs/kirigami-addons-1.7.0:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	kde-apps/kmime:6=
	>=kde-frameworks/breeze-icons-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcolorscheme-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-kmime-pre-26.04.patch" )

src_configure() {
	# marknote-1.4.0/src/config.h:9:7:
	# error: type ‘struct ConfigHelper’ violates the C++ One Definition Rule [-Werror=odr]
	#    9 | class ConfigHelper : public QObject
	#      |       ^
	# marknote-1.4.0_build/src/marknotesettings.cpp:10:7:
	# note: a type with different bases is defined in another translation unit
	#   10 | class ConfigHelper
	#      |       ^
	filter-lto

	ecm_src_configure
}
