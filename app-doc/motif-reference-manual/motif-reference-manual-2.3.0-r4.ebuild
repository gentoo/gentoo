# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Motif Reference Manual"
HOMEPAGE="https://motif.ics.com/
	https://www.ist.co.uk/motif/motif_refs.html"
SRC_URI="ftp://ftp.ics.com/openmotif/openmotif-${PV}-manual.pdf.tgz"
S="${WORKDIR}"

LICENSE="OPL"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-solaris"

DOCS="*.pdf"
