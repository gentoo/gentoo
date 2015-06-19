# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-clx/cl-clx-0.7.3.ebuild,v 1.8 2015/05/23 15:14:45 pacho Exp $

inherit common-lisp eutils

DESCRIPTION="CLX is the Common Lisp interface to the X11 protocol primarily for SBCL"
HOMEPAGE="http://ftp.linux.org.uk/pub/lisp/sbcl/ http://www.cliki.net/CLX"
SRC_URI="http://ftp.linux.org.uk/pub/lisp/sbcl/clx_${PV}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp
	sys-apps/texinfo"

CLPACKAGE=clx

S=${WORKDIR}/clx_${PV}

src_compile() {
	makeinfo manual/clx.texinfo || die
}

src_install() {
	for i in . demo test debug; do
		insinto /usr/share/common-lisp/source/clx/${i}
		doins "${S}"/${i}/*.lisp
	done
	insinto /usr/share/common-lisp/source/clx
	doins clx.asd NEWS CHANGES README README-R5 \
		excl* sock*
	insinto /usr/share/common-lisp/source/manual
	doins manual/clx.texinfo	# part of system definition
	common-lisp-system-symlink
	dodoc CHANGES NEWS README*
	doinfo clx.info*
}
