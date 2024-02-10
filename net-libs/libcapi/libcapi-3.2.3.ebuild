# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="9e7eb7789fef8ce712aa64f290aacbbececf2dfe"

inherit meson-multilib

DESCRIPTION="CAPI library used by various AVM products"
HOMEPAGE="https://gitlab.com/tabos/libcapi/"
SRC_URI="https://gitlab.com/tabos/${PN}/-/archive/v${PV}/${P}.tar.bz2"
S="${WORKDIR}/${PN}-v${PV}-${EGIT_COMMIT}"

LICENSE="GPL-2 GPL-2+ LGPL-2.1 GPL-3+"
SLOT="0/${PV}"
KEYWORDS="amd64 ppc x86"

multilib_src_configure() {
	meson_src_configure
}
