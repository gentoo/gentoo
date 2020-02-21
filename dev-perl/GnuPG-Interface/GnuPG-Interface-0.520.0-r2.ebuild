# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ALEXMV
DIST_VERSION=0.52
inherit perl-module

DESCRIPTION="Perl module interface to interacting with GnuPG"

SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-crypt/gnupg-1.2.1-r1
	virtual/perl-autodie
	>=virtual/perl-Math-BigInt-1.780.0
	>=dev-perl/Moo-0.91.11
	>=dev-perl/MooX-HandlesVia-0.1.4
	>=dev-perl/MooX-late-0.14.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
"

PATCHES=(
	"${FILESDIR}/${P}"-0001-fix-spelling-error-settting-should-be-setting.patch
	"${FILESDIR}/${P}"-0002-Generalize-the-test-suite.patch
	"${FILESDIR}/${P}"-0003-subkey-validity-of-an-key-when-we-have-established-n.patch
	"${FILESDIR}/${P}"-0004-ensure-that-test-covers-all-signatures.patch
	"${FILESDIR}/${P}"-0005-add-gpg_is_modern-to-test-suite.patch
	"${FILESDIR}/${P}"-0006-Modern-GnuPG-2.1-reports-more-detail-about-secret-ke.patch
	"${FILESDIR}/${P}"-0007-test-suite-match-plaintext-output-across-versions-of.patch
	"${FILESDIR}/${P}"-0008-fix-test_default_key_passphrase-when-passphrase-come.patch
	"${FILESDIR}/${P}"-0009-clean-up-trailing-whitespace.patch
	"${FILESDIR}/${P}"-0010-fix-capitalization-of-GnuPG.patch
	"${FILESDIR}/${P}"-0011-ommand_args-should-be-command_args.patch
	"${FILESDIR}/${P}"-0012-use-fingerprints-as-inputs-during-tests-to-demonstra.patch
	"${FILESDIR}/${P}"-0013-move-key-files-to-generic-names.patch
	"${FILESDIR}/${P}"-0014-fix-spelling-s-convience-convenience.patch
	"${FILESDIR}/${P}"-0015-added-new-secret-key-with-different-passphrase.patch
	"${FILESDIR}/${P}"-0016-Test-use-of-gpg-without-explicit-passphrase-agent-pi.patch
	"${FILESDIR}/${P}"-0017-Kill-any-GnuPG-agent-before-and-after-the-test-suite.patch
	"${FILESDIR}/${P}"-0018-Use-a-short-temporary-homedir-during-the-test-suite.patch
	"${FILESDIR}/${P}"-0019-Make-things-work-with-gpg1-assuming-plain-gpg-is-mod.patch
)

DIST_TEST=skip
# Nearly all tests succeed with this patchset and GnuPG 2.1 when running outside the
# emerge sandbox. However, the agent architecture is not really sandbox-friendly, so...
#
# Test Summary Report
# -------------------
# t/decrypt.t              (Wstat: 0 Tests: 6 Failed: 2)
#  Failed tests:  5-6
# Failed 1/22 test programs. 2/56 subtests failed.

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.];\nuse inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
