# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RJBS
DIST_VERSION=1.226
inherit perl-module

DESCRIPTION="Generate Globally/Universally Unique Identifiers (GUIDs/UUIDs)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

RDEPEND="
	virtual/perl-Digest-MD5
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
PERL_RM_FILES=(
	t/pod-coverage.t
	t/pod.t
)
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
