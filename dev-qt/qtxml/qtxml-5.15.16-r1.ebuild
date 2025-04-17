# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} != *9999* ]]; then
	QT5_KDEPATCHSET_REV=1
	KEYWORDS="~amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~x86"
fi

QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Implementation of SAX and DOM for the Qt5 framework"

IUSE=""

RDEPEND="=dev-qt/qtcore-${QT5_PV}*:5="
DEPEND="${RDEPEND}
	test? ( =dev-qt/qtnetwork-${QT5_PV}* )
"

QT5_TARGET_SUBDIRS=(
	src/xml
)

QT5_GENTOO_PRIVATE_CONFIG=(
	:xml
)

PATCHES=( "${FILESDIR}/${P}-CVE-2025-30348.patch" )
