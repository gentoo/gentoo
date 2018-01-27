# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Virtual for texi2dvi (and texi2pdf)"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

RDEPEND="sys-apps/texinfo
	virtual/latex-base
	|| ( dev-texlive/texlive-plaingeneric >=dev-texlive/texlive-plainextra-2013 )"
