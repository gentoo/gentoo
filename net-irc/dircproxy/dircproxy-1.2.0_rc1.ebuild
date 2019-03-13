# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils

MY_P="${P/_rc/-RC}"
DESCRIPTION="an IRC proxy server"
HOMEPAGE="https://code.google.com/p/dircproxy"
SRC_URI="https://dircproxy.googlecode.com/files/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog FAQ NEWS HACKING README* TODO INSTALL
}
