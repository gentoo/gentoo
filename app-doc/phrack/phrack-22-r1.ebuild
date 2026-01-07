# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${PN}${PV}
DESCRIPTION="A Hacker magazine by the community, for the community"
HOMEPAGE="http://www.phrack.org/"
SRC_URI="https://phrack.org/archives/tgz/${MY_P}.tar.gz -> ${MY_P}-r1.tar.gz"

S=${WORKDIR}

LICENSE="phrack"
SLOT="${PV}"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

src_install() {
	dodoc -r *
}
