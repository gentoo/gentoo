# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

MY_P="${P/-/_}"

DESCRIPTION="Attach/detach from interactive processes across the network"
HOMEPAGE="http://packages.debian.org/unstable/admin/detachtty"
SRC_URI="mirror://debian/pool/main/d/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DOCS=( INSTALL README )

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin "${PN}" attachtty
	doman "${PN}.1"
	dosym /usr/share/man/man1/detachtty.1 /usr/share/man/man1/attachtty.1
	einstalldocs
}
