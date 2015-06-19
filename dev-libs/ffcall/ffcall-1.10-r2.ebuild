# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/ffcall/ffcall-1.10-r2.ebuild,v 1.6 2014/03/02 09:39:44 pacho Exp $

inherit eutils flag-o-matic

# CLISP maintains ffcall now
CLISP_PACKAGE="clisp-2.41"

DESCRIPTION="foreign function call libraries"
HOMEPAGE="http://www.haible.de/bruno/packages-ffcall.html"
SRC_URI="mirror://sourceforge/clisp/${CLISP_PACKAGE}.tar.bz2"

# "Ffcall is under GNU GPL. As a special exception, if used in GNUstep
# or in derivate works of GNUstep, the included parts of ffcall are
# under GNU LGPL." -ffcall author
LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE=""

S=${WORKDIR}/${CLISP_PACKAGE}/${PN}

DEPEND=""
RDEPEND=""

src_compile() {
	# Because CHOST is set to (for example)
	# alphaev67-unknown-linux-gnu, CPU gets set to alphaev67 which
	# doesn't work in the Makefile (29 Jan 2004 agriffis)
	local cpu_setting
	[[ "${ARCH}" == "alpha" ]] && cpu_setting='CPU=alpha'

	append-flags -fPIC

	# Doc goes in datadir
	econf \
		--datadir=/usr/share/doc/${PF} \
		--enable-shared \
		|| die "./configure failed"
	# bug #298348
	emake -j1 ${cpu_setting} || die
}

src_install() {
	dodoc NEWS README
	dodir /usr/share/man
	emake DESTDIR=${D} install || die "Install failed"
}
