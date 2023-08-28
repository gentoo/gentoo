# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Provides lockspool utility"
HOMEPAGE="http://www.openbsd.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

PATCHES=(
	"${FILESDIR}"/${P}-respect-ldflags.patch
	"${FILESDIR}"/${P}-add-sys_file_h.patch
)

RDEPEND="!mail-mta/opensmtpd"

src_prepare() {
	default

	# This code should only be ran with Gentoo Prefix profiles
	if use prefix; then
		ebegin "Allowing unprivileged install"
		sed -i -e "s|-g 0 -o 0||g" Makefile
		eend $?
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" BINDNOW_FLAGS=""
}

src_install() {
	emake prefix="${ED}/usr" install
}
