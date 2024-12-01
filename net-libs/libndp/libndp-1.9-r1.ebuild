# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2 multilib-minimal

DESCRIPTION="Library for Neighbor Discovery Protocol"
HOMEPAGE="http://libndp.org https://github.com/jpirko/libndp"
SRC_URI="http://libndp.org/files/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

PATCHES=(
	# https://github.com/jpirko/libndp/issues/25
	"${FILESDIR}/${P}-gcc14.patch"
)

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	gnome2_src_configure \
		--disable-static \
		--enable-logging
}

multilib_src_install() {
	gnome2_src_install
}
