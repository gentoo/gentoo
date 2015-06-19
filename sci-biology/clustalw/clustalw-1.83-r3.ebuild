# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/clustalw/clustalw-1.83-r3.ebuild,v 1.10 2014/01/26 12:21:08 ago Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="General purpose multiple alignment program for DNA and proteins"
HOMEPAGE="http://www.embl-heidelberg.de/~seqanal/"
SRC_URI="ftp://ftp.ebi.ac.uk/pub/software/unix/clustalw/${PN}${PV}.UNIX.tar.gz"

LICENSE="clustalw"
SLOT="1"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE=""

S="${WORKDIR}"/${PN}${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-as-needed.patch

	sed \
		-e "/^CC/s:cc:$(tc-getCC):g" \
		-i makefile || die
	sed \
		-e "s%clustalw_help%/usr/share/doc/${PF}/clustalw_help%" \
		-i clustalw.c || die
}

src_install() {
	dobin clustalw
	dodoc README clustalv.doc clustalw.doc clustalw.ms
	insinto /usr/share/doc/${PF}
	doins clustalw_help
}
