# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Parallel bzip2 utility"
HOMEPAGE="https://github.com/kjn/lbzip2/"
SRC_URI="https://dev.gentoo.org/~whissi/dist/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug symlink"

RDEPEND="symlink? ( !app-arch/pbzip2[symlink] )"
DEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-2.3-s_isreg.patch
	"${FILESDIR}"/${P}-fix-unaligned.patch
)

src_configure() {
	local myeconfargs=(
		--disable-silent-rules
		$(use_enable debug tracing)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if use symlink; then
		dosym ${PN} /usr/bin/bzip2
		dosym lbunzip2 /usr/bin/bunzip2
	fi
}
