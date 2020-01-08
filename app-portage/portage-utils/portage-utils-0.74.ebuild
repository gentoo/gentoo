# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="Small and fast Portage helper tools written in C"
HOMEPAGE="https://wiki.gentoo.org/wiki/Portage-utils"
SRC_URI="mirror://gentoo/${P}.tar.xz
	https://dev.gentoo.org/~grobian/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls static"

RDEPEND="dev-libs/iniparser:0"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	static? ( dev-libs/iniparser:0[static-libs] )"

src_configure() {
	# Avoid slow configure+gnulib+make if on an up-to-date Linux system
	if use prefix || ! use kernel_linux || \
	   has_version '<sys-libs/glibc-2.10'
	then
		econf --with-eprefix="${EPREFIX}"
	else
		tc-export CC
	fi
}

src_compile() {
	emake NLS=$(usex nls) STATIC=$(usex static)
}
