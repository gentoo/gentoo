# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ESAYM
DIST_VERSION=1.95

inherit perl-module

DESCRIPTION="Connect to a local Clam Anti-Virus clamd service and send commands"

SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

RDEPEND="
	app-antivirus/clamav[clamapp(+)]
"
BDEPEND="
	${RDEPEND}
	app-alternatives/gzip
	app-arch/zip
	virtual/perl-ExtUtils-MakeMaker
"

# Test's can't be run in parallel because they internally spawn a
# clam server on the same shared socket
DIST_TEST="do"

src_prepare() {
	eapply_user

	# https://github.com/smith153/File-Scan-ClamAV/pull/7
	# https://rt.cpan.org/Public/Bug/Display.html?id=132387
	# https://rt.cpan.org/Public/Bug/Display.html?id=113277

	gzip -c testfiles/clamavtest > testfiles/clamavtest.gz || die
	zip testfiles/clamavtest.zip testfiles/clamavtest || die

	# Clamav changed signatures
	# https://docs.clamav.net/manual/Signatures/SignatureNames.html
	sed -i -e 's/Eicar-Test-Signature/Win.Test.EICAR_HDB-1/' t/05streamscan.t || die
}

src_test() {
	if [[ "${TEST_SCAN_CLAMAV:-0}" == "1" || -n "${DIST_TEST_OVERRIDE}" ]]; then
		perl_rm_files t/pod-coverage.t t/pod.t
		perl-module_src_test
	else
		einfo "Skipping Tests."
		einfo
		einfo "Tests require a manually and correctly configured ClamAV."
		einfo
		einfo "Set TEST_SCAN_CLAMAV=1 if you wish to run this test and have"
		einfo "configured ClamAV"
	fi
}
