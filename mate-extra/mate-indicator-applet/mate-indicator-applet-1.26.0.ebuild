# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

DESCRIPTION="MATE indicator applet"
LICENSE="GPL-3 GPL-3+ LGPL-2+ LGPL-3+"
SLOT="0"

IUSE=""

COMMON_DEPEND="
	>=dev-libs/libindicator-0.4:3
	>=mate-base/mate-panel-1.17.0
	>=x11-libs/gtk+-3.22:3
"

RDEPEND="${COMMON_DEPEND}
	virtual/libintl
"

BDEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"
