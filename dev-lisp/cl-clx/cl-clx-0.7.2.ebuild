# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-clx/cl-clx-0.7.2.ebuild,v 1.2 2012/09/29 16:56:32 ulm Exp $

inherit common-lisp eutils

DESCRIPTION="Portable CLX"
HOMEPAGE="http://ftp.linux.org.uk/pub/lisp/sbcl/ http://www.cliki.net/CLX"
SRC_URI="http://ftp.linux.org.uk/pub/lisp/sbcl/clx_${PV}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-lisp/common-lisp-controller"

CLPACKAGE=clx

S=${WORKDIR}/clx_${PV}

src_install() {
	for i in . demo test debug; do
		insinto /usr/share/common-lisp/source/clx/${i}
		doins ${S}/${i}/*.lisp
	done
	insinto /usr/share/common-lisp/source/clx
	doins clx.asd NEWS CHANGES README README-R5 \
		excl* sock*
	insinto /usr/share/common-lisp/source/manual
	doins manual/clx.texinfo
	common-lisp-system-symlink
	dodoc CHANGES NEWS README*
}
