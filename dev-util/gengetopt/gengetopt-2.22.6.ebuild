# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gengetopt/gengetopt-2.22.6.ebuild,v 1.2 2013/05/02 03:56:39 patrick Exp $

EAPI=5

inherit eutils autotools

DESCRIPTION="A tool to write command line option parsing code for C programs"
HOMEPAGE="http://www.gnu.org/software/gengetopt/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

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
