# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A (shell-) script compiler/scrambler"
HOMEPAGE="https://neurobin.org/projects/softwares/unix/shc/"
SRC_URI="https://github.com/neurobin/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

src_install() {
	dobin src/shc
	doman shc.1
	dodoc ChangeLog README.md
}
