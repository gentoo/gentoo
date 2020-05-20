# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qt5-build

DESCRIPTION="Serial port abstraction library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm ~arm64 ~hppa ~ppc ppc64 ~sparc x86"
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}
	virtual/libudev:=
"
RDEPEND="${DEPEND}"

src_prepare() {
	# make sure we link against libudev
	sed -i -e 's/:qtConfig(libudev)//' \
		src/serialport/serialport-lib.pri || die

	qt5-build_src_prepare
}
