# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Command-line interface to various pastebins"
HOMEPAGE="http://wgetpaste.zlin.dk/"
SRC_URI="http://wgetpaste.zlin.dk/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="+ssl"

DEPEND=""
RDEPEND="net-misc/wget[ssl?]"

PATCHES=( "${FILESDIR}"/${PN}-remove-dead.patch )

src_prepare() {
	sed -i -e "s:/etc:\"${EPREFIX}\"/etc:g" wgetpaste || die
	default
}

src_install() {
	dobin ${PN}
	insinto /usr/share/zsh/site-functions
	doins _wgetpaste
}
