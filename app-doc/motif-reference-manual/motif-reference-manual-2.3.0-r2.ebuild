# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit readme.gentoo-r1

DESCRIPTION="Motif Reference Manual"
HOMEPAGE="http://www.motifzone.net/"
SRC_URI="ftp://ftp.ics.com/openmotif/openmotif-${PV}-manual.pdf.tgz"

LICENSE="OPL"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

S="${WORKDIR}"
DOCS="*.pdf"

src_install() {
	local DOC_CONTENTS="The source code for the manual is available at
		ftp://ftp.ics.com/openmotif/openmotif-${PV}-manual.src.tgz"
	default
	readme.gentoo_create_doc
}
