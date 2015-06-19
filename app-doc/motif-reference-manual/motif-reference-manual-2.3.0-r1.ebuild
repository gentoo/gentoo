# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/motif-reference-manual/motif-reference-manual-2.3.0-r1.ebuild,v 1.2 2013/08/03 15:28:36 ulm Exp $

EAPI=4

inherit readme.gentoo

DESCRIPTION="Motif Reference Manual"
HOMEPAGE="http://www.motifzone.net/"
SRC_URI="ftp://ftp.ics.com/openmotif/openmotif-${PV}-manual.pdf.tgz"

LICENSE="OPL"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

S="${WORKDIR}"
DOCS="*.pdf"
DOC_CONTENTS="The source code for the manual is available at
	ftp://ftp.ics.com/openmotif/openmotif-${PV}-manual.src.tgz"
