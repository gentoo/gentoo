# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mate

MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"
fi

DESCRIPTION="MATE indicator applet"
LICENSE="GPL-3 GPL-3+ LGPL-2+ LGPL-3+"
SLOT="0"

COMMON_DEPEND="
	dev-libs/libayatana-indicator:3
	>=mate-base/mate-panel-1.28.0
	>=x11-libs/gtk+-3.22:3
"

RDEPEND="${COMMON_DEPEND}
	virtual/libintl
"

BDEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	mate_src_configure \
		--with-ayatana-indicators
}
