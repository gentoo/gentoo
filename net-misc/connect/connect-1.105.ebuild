# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="SSH Proxy Command"
HOMEPAGE="https://github.com/gotoh/ssh-connect"
SRC_URI="https://github.com/gotoh/ssh-connect/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

S="${WORKDIR}/ssh-connect-${PV}"

src_prepare() {
	default
	sed -i -e "s/CFLAGS=/CFLAGS+=/g" -e "s/CC=/CC?=/g" Makefile || die
}

src_install() {
	dobin ${PN}
	dodoc doc/manual.txt
}
