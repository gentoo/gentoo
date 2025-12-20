# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ANDYA
DIST_VERSION=0.16
inherit perl-module

DESCRIPTION="Change nature of data within a structure"

SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 ~sparc x86"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.10.0
"
BDEPEND="${RDEPEND}
	dev-perl/Devel-CheckLib
"

PERL_RM_FILES=(
	"t/00pod.t"
	"t/06signature.t"
	"inc/IO/CaptureOutput.pm"
	"inc/IO/Devel/CheckLib.pm"
)

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
