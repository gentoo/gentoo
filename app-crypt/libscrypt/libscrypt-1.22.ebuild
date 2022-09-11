# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Shared library to impliment the scrypt algorithm"
HOMEPAGE="https://github.com/technion/libscrypt"
SRC_URI="https://github.com/technion/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv sparc x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
	export LIBDIR=${PREFIX}/$(get_libdir)
	export CFLAGS_EXTRA="${CFLAGS}"
	export LDFLAGS_EXTRA="${LDFLAGS}"
	export PREFIX=/usr
	unset CFLAGS
	unset LDFLAGS
}

src_compile() {
	emake \
		CC="$(tc-getCC)"
}
