# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 toolchain-funcs

MY_PV=${PV/./-}

DESCRIPTION="minimal dumb-terminal emulation program"
HOMEPAGE="https://gitlab.com/wsakernel/picocom"
SRC_URI="
	https://gitlab.com/wsakernel/${PN}/-/archive/${MY_PV}/${PN}-${MY_PV}.tar.bz2
	!man? ( https://dev.gentoo.org/~ceamac/${CATEGORY}/${PN}/${P}.1.bz2 )
"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc ppc64 ~riscv"
IUSE="+man"

BDEPEND="man? ( dev-go/go-md2man )"

src_prepare() {
	default

	use man || cp "${WORKDIR}"/${P}.1 picocom.1
}

src_compile() {
	emake CFLAGS="${CFLAGS} -Wall" CC="$(tc-getCC)"

	use man && emake doc
}

src_install() {
	dobin picocom pc{asc,xm,ym,zm}
	dodoc CONTRIBUTORS CONTRIBUTORS.old README.md
	dobashcomp bash_completion/picocom

	doman picocom.1
}
