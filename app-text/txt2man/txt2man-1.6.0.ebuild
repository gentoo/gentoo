# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Scripts to convert regular ASCII text to man pages"
HOMEPAGE="https://github.com/mvertes/txt2man"
SRC_URI="https://github.com/mvertes/txt2man/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE=""

RDEPEND="app-shells/bash
	sys-apps/gawk"

S=${WORKDIR}/${PN}-${P}

src_compile() { :; }

src_install() {
	dobin bookman src2man txt2man
	doman *.1
	dodoc Changelog README
}
