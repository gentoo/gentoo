# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="bc symlink"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Base/Alternatives"
SRC_URI=""
S=${WORKDIR}

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+gnu gh"
REQUIRED_USE="^^ ( gnu gh )"

RDEPEND="
	gnu? ( >=sys-devel/bc-1.07.1-r6 )
	gh? ( sci-calculators/bc-gh )
	!<sys-devel/bc-1.07.1-r6
"

src_install() {
	if use gnu; then
		dosym bc-reference /usr/bin/bc
		dosym dc-reference /usr/bin/dc
		newman - bc.1 <<<".so bc-reference.1"
		newman - dc.1 <<<".so dc-reference.1"
	elif use gh; then
		dosym bc-gh /usr/bin/bc
		dosym dc-gh /usr/bin/dc
		newman - bc.1 <<<".so bc-gh.1"
		newman - dc.1 <<<".so dc-gh.1"
	else
		die "Invalid USE flag combination (broken REQUIRED_USE?)"
	fi
}
