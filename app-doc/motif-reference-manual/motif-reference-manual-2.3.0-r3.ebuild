# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1

DESCRIPTION="Motif Reference Manual"
HOMEPAGE="http://www.motifzone.net/"
SRC_URI="ftp://ftp.ics.com/openmotif/openmotif-${PV}-manual.pdf.tgz"
S="${WORKDIR}"

LICENSE="OPL"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

DOCS="*.pdf"

src_install() {
	default
	local DOC_CONTENTS="The source code for the manual is available at
		ftp://ftp.ics.com/openmotif/openmotif-${PV}-manual.src.tgz"
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
