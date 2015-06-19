# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/texi2dvi/texi2dvi-0.ebuild,v 1.8 2014/03/31 20:34:06 ulm Exp $

EAPI=5

DESCRIPTION="Virtual for texi2dvi (and texi2pdf)"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

RDEPEND="sys-apps/texinfo
	virtual/latex-base
	|| ( >=dev-texlive/texlive-plainextra-2013 dev-texlive/texlive-texinfo )"
