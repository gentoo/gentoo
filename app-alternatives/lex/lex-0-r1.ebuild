# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="lex symlinks"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Base/Alternatives"
SRC_URI=""
S=${WORKDIR}

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+flex reflex"
REQUIRED_USE="^^ ( flex reflex )"

RDEPEND="
	flex? ( >=sys-devel/flex-2.6.4-r5 )
	reflex? ( sys-devel/reflex )
	!<sys-devel/flex-2.6.4-r5
"

src_install() {
	if use flex; then
		dosym flex /usr/bin/lex
		newman - lex.1 <<<".so flex.1"

		newenvd - 90lex <<-EOF
			LEX=flex
		EOF
	elif use reflex; then
		dosym reflex /usr/bin/lex
		newman - lex.1 <<<".so reflex.1"

		newenvd - 90lex <<-EOF
			LEX=reflex
		EOF
	else
		die "Invalid USE flag combination (broken REQUIRED_USE?)"
	fi
}
