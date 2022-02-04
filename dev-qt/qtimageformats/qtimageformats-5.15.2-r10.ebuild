# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=cb82c74310837fe4e832c8ab72176a5d63e4355f
inherit qt5-build

DESCRIPTION="Additional format plugins for the Qt image I/O system"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm arm64 ~hppa ppc64 ~riscv ~sparc x86"
fi

IUSE="mng"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtgui-${QT5_PV}*
	media-libs/libwebp:=
	media-libs/tiff:0
	mng? ( media-libs/libmng:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	sed -e 's/qtConfig(jasper)/false:/' \
		-i src/plugins/imageformats/imageformats.pro || die
	qt_use_disable_config mng mng src/plugins/imageformats/imageformats.pro

	qt5-build_src_configure
}
