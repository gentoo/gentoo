# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MATE_LA_PUNT=yes

inherit mate

MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
fi

DESCRIPTION="Caja Actions"
HOMEPAGE="https://github.com/mate-desktop/caja-actions"

LICENSE="GPL-2+"
SLOT="0"

COMMON_DEPEND="
	>=dev-libs/glib-2.66
	>=x11-libs/gtk+-3.22:3
	>=gnome-base/libgtop-2.23.1:2=
	dev-libs/libxml2
	>=mate-base/caja-1.28.0
	x11-libs/libSM
	virtual/libintl
"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.19.8
	>=dev-build/autoconf-2.53:*
	>=dev-build/libtool-2.2.6:2
	virtual/pkgconfig
"
