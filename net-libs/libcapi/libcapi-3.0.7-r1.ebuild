# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="CAPI library used by AVM products"
HOMEPAGE="http://www.tabos.org/ffgtk"
SRC_URI="http://www.tabos.org/ffgtk/download/libcapi20-${PV}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="!net-dialup/capi4k-utils"
DEPEND="${RDEPEND}"

S="${WORKDIR}/capi20"
PATCHES=( "${FILESDIR}"/${P}-remove-libcapi20dyn.patch )

src_prepare() {
	default
	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
		econf --disable-static
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
