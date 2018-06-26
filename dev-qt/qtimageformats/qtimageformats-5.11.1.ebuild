# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build

DESCRIPTION="Additional format plugins for the Qt image I/O system"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~x86"
fi

IUSE="jpeg2k mng"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}
	media-libs/libwebp:=
	media-libs/tiff:0
	jpeg2k? ( media-libs/jasper:= )
	mng? ( media-libs/libmng:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	qt_use_compile_test jpeg2k jasper
	qt_use_compile_test mng libmng
	qt5-build_src_configure
}
