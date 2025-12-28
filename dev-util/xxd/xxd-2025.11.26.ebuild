# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 toolchain-funcs

VIM_VERSION="9.1.1928"

DESCRIPTION="Standalone version of Vim's xxd"
HOMEPAGE="
	https://www.vim.org
	https://github.com/vim/vim
"
SRC_URI="https://github.com/vim/vim/archive/v${VIM_VERSION}.tar.gz -> vim-${VIM_VERSION}.tar.gz"

S="${WORKDIR}/vim-${VIM_VERSION}/src/xxd"
LICENSE="|| ( GPL-2 MIT )"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="!<app-editors/vim-core-9.1.1652-r1"

src_prepare() {
	default

	# international man pages need some renaming:
	# xxd-<lang>.UTF-8.1 -> xxd.<lang>.1
	cd ../../runtime/doc || die
	local f newname
	for f in xxd-*.UTF-8.1 ; do
		newname=${f//xxd-/xxd.}
		newname=${newname//UTF-8\./}
		mv -f "${f}" "${newname}" || die
	done
}

src_compile() {
	tc-export CC
	export {C,CPP,LD}FLAGS
	emake
}

src_install() {
	dobin xxd
	doman ../../runtime/doc/xxd*.1
	newbashcomp "${FILESDIR}"/xxd-completion xxd
}
