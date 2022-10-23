# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manage config files in $HOME via fake bare git repositories"
HOMEPAGE="https://github.com/RichiH/vcsh"
SRC_URI="https://github.com/RichiH/vcsh/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-vcs/git"

src_configure() {
	# bash for https://github.com/RichiH/vcsh/issues/325
	CONFIG_SHELL="${BROOT}"/bin/bash econf
}

src_install() {
	default

	mv "${ED}"/usr/share/doc/${PN} "${ED}"/usr/share/doc/${PF} || die

	dodoc -r doc/sample_hooks
}
