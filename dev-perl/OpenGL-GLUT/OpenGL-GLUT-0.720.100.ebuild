# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETJ
DIST_VERSION=0.7201

inherit perl-module

DESCRIPTION="Perl bindings to GLUT/FreeGLUT GUI toolkit"

SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

RDEPEND="
	media-libs/freeglut:=
	x11-libs/libICE:=
	x11-libs/libXext:=
	x11-libs/libXi:=
	x11-libs/libXmu:=
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.720.0-no-display.patch
)

src_prepare() {
	# Per Fedora, "This is basically not a test, but an interactive demo"
	mv test.pl demo.pl || die

	# Unbundle GL headers
	find include -type f -delete || die

	perl-module_src_prepare
}
