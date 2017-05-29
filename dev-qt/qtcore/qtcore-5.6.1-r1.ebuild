# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtbase"
QT5_MODULE_EXAMPLES_SUBDIRS=("examples/corelib")
inherit qt5-build

DESCRIPTION="Cross-platform application development framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="icu systemd"

DEPEND="
	dev-libs/glib:2
	>=dev-libs/libpcre-8.38[pcre16,unicode]
	>=sys-libs/zlib-1.2.5
	virtual/libiconv
	icu? ( dev-libs/icu:= )
	systemd? ( sys-apps/systemd:= )
	examples? (
		~dev-qt/qtwidgets-${PV}
		~dev-qt/qtnetwork-${PV}
	)
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/tools/bootstrap
	src/tools/moc
	src/tools/rcc
	src/corelib
	src/tools/qlalr
)

src_configure() {
	local myconf=(
		$(qt_use icu)
		$(qt_use systemd journald)
	)
	qt5-build_src_configure
}
