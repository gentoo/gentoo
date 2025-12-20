# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETJ
DIST_VERSION=0.7002

inherit perl-module

DESCRIPTION="Perl interface providing graphics display using OpenGL"

SLOT="0"
KEYWORDS="amd64 arm ppc ~ppc64 x86"
IUSE="examples"

RDEPEND="
	media-libs/freeglut:=
	x11-libs/libICE:=
	x11-libs/libXext:=
	x11-libs/libXi:=
	x11-libs/libXmu:=
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

mydoc="Release_Notes"

PATCHES=(
	"${FILESDIR}"/${PN}-0.700.200-no-display.patch
)

src_prepare() {
	# This should be merely moved to t/ as it gets
	# installed to OS otherwise.
	# But it presently fails tests, and can't be made not to.
	# ( And will need virtualx when it can )
	# Something to do with OpenGL implementation ala eselect.
	perl_rm_files "test.pl"
	perl-module_src_prepare
}

src_compile() {
	#sed -i -e 's/PERL_DL_NONLAZY=1//' Makefile || die
	perl-module_src_compile
}

src_install() {
	perl-module_src_install
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
