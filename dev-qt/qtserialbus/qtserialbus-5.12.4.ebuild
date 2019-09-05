# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qt5-build

DESCRIPTION="Qt module to access CAN, ModBus, and other industrial serial buses and protocols"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

IUSE=""

PATCHES+=(
	"${FILESDIR}/${P}-canbus-missing-header-w-linux-headers.patch" # QTBUG-76957
)

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtnetwork-${PV}
	~dev-qt/qtserialport-${PV}
"
RDEPEND="${DEPEND}"
