# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MATE_LA_PUNT=yes

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Caja Actions"
HOMEPAGE="https://github.com/mate-desktop/caja-actions"

LICENSE="GPL-2+"
SLOT="0"

COMMON_DEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.22:3
	>=gnome-base/libgtop-2.23.1:2=
	dev-libs/libxml2
	>=mate-base/caja-1.17
	x11-libs/libSM
	virtual/libintl
"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.19.8
	>=sys-devel/autoconf-2.53:*
	>=sys-devel/libtool-2.2.6:2
	virtual/pkgconfig
"
