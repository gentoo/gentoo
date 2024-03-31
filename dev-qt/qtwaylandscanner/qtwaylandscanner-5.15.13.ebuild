# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_MODULE="qtwayland"
inherit qt5-build

DESCRIPTION="Tool that generates certain boilerplate C++ code from Wayland protocol xml spec"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DEPEND="=dev-qt/qtcore-${QT5_PV}*:5="
RDEPEND="${DEPEND}
	!<dev-qt/qtwayland-5.15.3:5
"

QT5_TARGET_SUBDIRS=(
	src/qtwaylandscanner
)
