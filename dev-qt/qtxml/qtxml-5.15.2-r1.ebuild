# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Implementation of SAX and DOM for the Qt5 framework"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/qtbase-${PV}-gcc11.patch.xz"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
fi

IUSE=""

RDEPEND="
	~dev-qt/qtcore-${PV}:5=
"
DEPEND="${RDEPEND}
	test? ( ~dev-qt/qtnetwork-${PV} )
"

QT5_TARGET_SUBDIRS=(
	src/xml
)

QT5_GENTOO_PRIVATE_CONFIG=(
	:xml
)

PATCHES=( "${WORKDIR}/qtbase-${PV}-gcc11.patch" ) # bug 752012
