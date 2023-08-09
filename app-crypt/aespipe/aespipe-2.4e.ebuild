# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Encrypts data from stdin to stdout"
HOMEPAGE="https://loop-aes.sourceforge.net"
SRC_URI="https://loop-aes.sourceforge.net/aespipe/${PN}-v${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="+asm cpu_flags_x86_aes cpu_flags_x86_padlock static"
DEPEND=""
RDEPEND="app-arch/sharutils
	app-crypt/gnupg"

S="${WORKDIR}/${PN}-v${PV}"

src_configure() {
	use static && append-ldflags -static
	econf \
		$(use_enable asm) \
		$(use_enable cpu_flags_x86_aes intelaes) \
		$(use_enable cpu_flags_x86_padlock padlock)
}
