# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MAREKR
DIST_VERSION=1.63
inherit perl-module

DESCRIPTION="POD filters and translators"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-File-Spec
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
src_prepare() {
	# This avoids filename collision in /usr/bin on perl <5.32
	# which previously had this script. But no decollisioning needed for the modules
	# due to that already being handled by @INC stuff
	# Though, it does mean that with this installed, the podselect shipped in perl <5.32
	# will consume modules shipped by this ebuild, but that doesn't look very problematic
	# looking at the code (its just a dumb shim with arg-parsing)
	if has_version -r "<dev-lang/perl-5.32"; then
		einfo "Stripping podselect for compat with perl <5.32";
		perl_rm_files "scripts/podselect.PL" \
			"t/pod/podselect.t"
		eapply "${FILESDIR}/${PN}-1.63-no-binscript.patch"
	fi
	perl-module_src_prepare
}
