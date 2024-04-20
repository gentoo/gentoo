# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Shared library to implement the scrypt algorithm"
HOMEPAGE="https://github.com/technion/libscrypt"
SRC_URI="https://github.com/technion/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv sparc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.22-no-clobber-fortify-source.patch
)

src_configure() {
	export LIBDIR=${PREFIX}/$(get_libdir)
	export CFLAGS_EXTRA="${CFLAGS}"
	export LDFLAGS_EXTRA="${LDFLAGS}"
	export PREFIX=/usr
	unset CFLAGS
	unset LDFLAGS
}

src_compile() {
	emake CC="$(tc-getCC)"
}
