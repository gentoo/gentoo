# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

MY_P=${PN/-/_}-${PV}
DESCRIPTION="NSS module to provide NIS support"
HOMEPAGE="https://github.com/thkukuk/libnss_nis"
SRC_URI="https://github.com/thkukuk/libnss_nis/releases/download/v${PV}/${MY_P}.tar.xz"
S="${WORKDIR}"/${MY_P}

LICENSE="LGPL-2.1+ BSD ISC"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>net-libs/libnsl-0:=[${MULTILIB_USEDEP}]
	net-libs/libtirpc:=[${MULTILIB_USEDEP}]
	!<sys-libs/glibc-2.26
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

multilib_src_configure() {
	local myconf=(
		--enable-shared
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
