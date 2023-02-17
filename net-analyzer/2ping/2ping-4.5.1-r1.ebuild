# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit bash-completion-r1 distutils-r1

DESCRIPTION="A bi-directional ping utility"
HOMEPAGE="https://www.finnie.org/software/2ping/"
SRC_URI="https://www.finnie.org/software/2ping/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~riscv ~x86"
IUSE="server"

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install

	doman doc/2ping.1
	dodoc doc/{2ping-protocol-examples.py,2ping-protocol.md}

	newbashcomp 2ping.bash_completion 2ping
	dosym 2ping $(get_bashcompdir)/2ping6

	use server && {
		doinitd "${FILESDIR}"/2pingd
		newconfd "${FILESDIR}"/2pingd.conf 2pingd
	}
}
