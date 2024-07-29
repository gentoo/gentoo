# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit toolchain-funcs multilib-minimal

MY_PV="${PV//_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="SELinux binary policy representation library"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/selinux.git"
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="https://github.com/SELinuxProject/selinux/releases/download/${MY_PV}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~riscv ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0/2"
IUSE="+static-libs"

# tests are not meant to be run outside of the full SELinux userland repo
RESTRICT="test"

src_prepare() {
	eapply_user
	multilib_copy_sources
}

my_make() {
	emake \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="\$(PREFIX)/$(get_libdir)" \
		SHLIBDIR="${EPREFIX}/$(get_libdir)" \
		"${@}"
}

multilib_src_compile() {
	tc-export CC AR RANLIB

	local -x CFLAGS="${CFLAGS} -fno-semantic-interposition"

	my_make
}

multilib_src_install() {
	my_make DESTDIR="${D}" install
	use static-libs || rm "${ED}"/usr/$(get_libdir)/*.a || die
}
