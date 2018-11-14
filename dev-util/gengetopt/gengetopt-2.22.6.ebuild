# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils autotools

DESCRIPTION="A tool to write command line option parsing code for C programs"
HOMEPAGE="https://www.gnu.org/software/gengetopt/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm x86 ~x64-cygwin ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${FILESDIR}"/${P}-no-docs.patch
	epatch "${FILESDIR}"/${P}-docdirs.patch
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die
	eautoreconf
}

src_configure() {
	econf --docdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_install() {
	default
	docompress -x /usr/share/doc/${PF}/examples
}
