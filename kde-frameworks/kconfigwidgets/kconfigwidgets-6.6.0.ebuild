# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_DESIGNERPLUGIN="true"
PVCUT=$(ver_cut 1-2)
QTMIN=6.6.2
inherit ecm frameworks.kde.org

DESCRIPTION="Framework providing an assortment of configuration-related widgets"

LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

CMAKE_SKIP_TESTS=(
	# bugs: 864250
	kstandardactiontest
	# bug 926497
	klanguagenametest
)

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,widgets]
	=kde-frameworks/kcodecs-${PVCUT}*:6
	=kde-frameworks/kcolorscheme-${PVCUT}*:6
	=kde-frameworks/kconfig-${PVCUT}*:6
	=kde-frameworks/kcoreaddons-${PVCUT}*:6
	=kde-frameworks/kguiaddons-${PVCUT}*:6
	=kde-frameworks/ki18n-${PVCUT}*:6
	=kde-frameworks/kwidgetsaddons-${PVCUT}*:6
"
DEPEND="${RDEPEND}
	test? ( =kde-frameworks/kconfig-${PVCUT}*:6[dbus] )
"
