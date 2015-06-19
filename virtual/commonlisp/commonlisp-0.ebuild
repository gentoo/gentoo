# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/commonlisp/commonlisp-0.ebuild,v 1.3 2014/03/26 08:46:37 ulm Exp $

EAPI=5

DESCRIPTION="Virtual for Common Lisp"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ~sparc x86"

RDEPEND="|| ( dev-lisp/sbcl
	dev-lisp/clisp
	dev-lisp/clozurecl
	dev-lisp/cmucl
	dev-lisp/ecls
	dev-lisp/openmcl )"
