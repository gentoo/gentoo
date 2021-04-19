# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic

PATCH="${P/-/_}-10.diff"
DESCRIPTION="NES emulation for Linux/x86"
HOMEPAGE="http://nestra.linuxgames.com/"
SRC_URI="http://nestra.linuxgames.com/${P}.tar.gz
	mirror://debian/pool/contrib/n/nestra/${PATCH}.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/libX11[abi_x86_32(-)]"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	eapply "${WORKDIR}"/${PATCH}
	eapply "${FILESDIR}"/${P}-exec-stack.patch
	eapply "${FILESDIR}"/${P}-include.patch

	append-ldflags -Wl,-z,noexecstack
	use amd64 && multilib_toolchain_setup x86

	sed -i \
		-e "s:-L/usr/X11R6/lib:${LDFLAGS}:" \
		-e 's:-O2 ::' \
		-e "s:gcc:$(tc-getCC) ${CFLAGS}:" \
		-e "s:ld:$(tc-getLD) -m elf_i386 $(raw-ldflags):" \
		Makefile || die
}

src_compile() {
	use amd64 && multilib_toolchain_setup x86
	default
}

src_install() {
	dobin nestra
	einstalldocs
	doman nestra.6
}
