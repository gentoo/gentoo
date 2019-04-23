# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal

DESCRIPTION="NSS module to provide compat entry support"
HOMEPAGE="https://github.com/thkukuk/libnss_compat"
SRC_URI="https://github.com/thkukuk/libnss_compat/archive/libnss_compat-${PV}.tar.gz"

LICENSE="LGPL-2.1+ BSD ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>net-libs/libnsl-0:0=[${MULTILIB_USEDEP}]
	net-libs/libtirpc:0=[${MULTILIB_USEDEP}]
	!<sys-libs/glibc-2.26
	!>=sys-libs/glibc-2.27
"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

S=${WORKDIR}/libnss_compat-libnss_compat-${PV}

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		--enable-shared
		--disable-static
	)
	ECONF_SOURCE=${S} econf "${myconf[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
