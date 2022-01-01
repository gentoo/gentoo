# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="MATE default icon themes"
LICENSE="CC-BY-SA-3.0 CC-PD GPL-1+"
SLOT="0"

COMMON_DEPEND=">=x11-themes/hicolor-icon-theme-0.10"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	>=x11-misc/icon-naming-utils-0.8.7:0
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

RESTRICT="binchecks strip"

src_configure() {
	mate_src_configure --enable-icon-mapping
}
