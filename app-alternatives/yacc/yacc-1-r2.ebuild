# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="yacc symlinks"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Base/Alternatives"
SRC_URI=""
S=${WORKDIR}

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+bison byacc reference"
REQUIRED_USE="^^ ( bison byacc reference )"

RDEPEND="
	bison? ( >=sys-devel/bison-3.8.2-r1 )
	byacc? ( dev-util/byacc )
	reference? ( >=dev-util/yacc-1.9.1-r7 )
	!<dev-util/yacc-1.9.1-r7
	!<sys-devel/bison-3.8.2-r1
"

src_install() {
	if use bison; then
		# bison installs its own small wrapper script 'yacc-bison'
		# around bison(1).
		dosym yacc.bison /usr/bin/yacc
		newman - yacc.1 <<<".so yacc.bison.1"

		# Leaving this for now to be safe, as it's closer to pre-alternatives
		# status quo to leave it unset and let autoconf probe for Bison by itself
		# as it prefers it anyway, and might be a CPP-like situation wrt
		# calling bison or bison -y if YACC is set.
		#newenvd - 90yacc <<-EOF
		#	YACC=yacc.bison
		#EOF
	elif use byacc; then
		dosym byacc /usr/bin/yacc
		newman - yacc.1 <<<".so byacc.1"

		newenvd - 90yacc <<-EOF
			YACC=byacc
		EOF
	elif use reference; then
		dosym yacc-reference /usr/bin/yacc
		newman - yacc.1 <<<".so yacc-reference.1"

		newenvd - 90yacc <<-EOF
			YACC=yacc
		EOF
	else
		die "Invalid USE flag combination (broken REQUIRED_USE?)"
	fi
}
