# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=CHM
DIST_VERSION=0.6704

inherit perl-module eutils

DESCRIPTION="Perl interface providing graphics display using OpenGL"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	media-libs/freeglut:0=
	x11-libs/libICE:0=
	x11-libs/libXext:0=
	x11-libs/libXi:0=
	x11-libs/libXmu:0="
DEPEND="${RDEPEND}"

mydoc="Release_Notes"

src_prepare() {
	eapply "${FILESDIR}"/${PN}-0.66-no-display.patch
	# This should be merely moved to t/ as it gets
	# installed to OS otherwise.
	# But it presently fails tests, and can't be made not to.
	# ( And will need virtualx when it can )
	# Something to do with OpenGL implementation ala eselect.
	perl_rm_files "test.pl";
	perl-module_src_prepare
}

src_compile() {
	sed -i -e 's/PERL_DL_NONLAZY=1//' Makefile || die
	perl-module_src_compile
}
src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
