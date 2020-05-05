# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHAY
DIST_VERSION=1.42
inherit depend.apache perl-module

DESCRIPTION="Test.pm wrapper with helpers for testing Apache"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ppc ~ppc64 sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="virtual/perl-ExtUtils-MakeMaker"

need_apache

PATCHES=(
	"${FILESDIR}/${PN}-1.400.0-catfile-import.patch"
	"${FILESDIR}/${PN}-1.400.0-phpclient.patch"
)

pkg_setup() {
	perl_set_version
}

src_install() {
	# This is to avoid conflicts with a deprecated Apache::Test stepping
	# in and causing problems/install errors
	if [ -f  "${S}"/.mypacklist ];
	then
		rm -f "${S}"/.mypacklist
	fi
	perl-module_src_install
}
# Parallel tests seem to be bad.
DIST_TEST="do"

optdep_notice() {
	local i
	elog "This package has several modules which may require additional dependencies"
	elog "to use. However, it is up to you to install them separately if you need this"
	elog "optional functionality:"
	elog
	i="$(if has_version 'www-apache/mod_perl'; then echo '[I]'; else echo '[ ]'; fi)"
	elog " $i www-apache/mod_perl"
	elog "     - Running Perl code natively in Apache via"
	elog "       Apache::TestHandler, Apache::TestReportPerl, or Apache::TestSmokePerl"

	if use test; then
		elog
		elog "This module will perform additional tests if these dependencies are"
		elog "pre-installed"
	fi
}
src_test() {
	optdep_notice
	echo
	local MODULES=(
		"Apache::Test ${DIST_VERSION}"
		"Apache::Test5005compat 0.01"
		"Apache::TestBuild"
		"Apache::TestClient"
		"Apache::TestCommon"
		"Apache::TestCommonPost"
		"Apache::TestConfig"
		"Apache::TestConfigC"
		"Apache::TestConfigPHP"
		"Apache::TestConfigParrot"
		"Apache::TestConfigParse"
		"Apache::TestConfigPerl"
		"Apache::TestHarness"
		"Apache::TestHarnessPHP"
		"Apache::TestMB"
		"Apache::TestMM"
		"Apache::TestPerlDB"
		"Apache::TestReport"
		"Apache::TestRequest"
		"Apache::TestRun"
		"Apache::TestRunPHP 1.00"
		"Apache::TestRunParrot 1.00"
		"Apache::TestRunPerl 1.00"
		"Apache::TestSSLCA"
		"Apache::TestServer"
		"Apache::TestSmoke"
		"Apache::TestSort"
		"Apache::TestTrace 0.01"
		"Apache::TestUtil 0.02"
		"Bundle::ApacheTest ${DISTVERSION}"
	)
	has_version "www-apache/mod_perl" && MODULES+=(
		"Apache::TestHandler"
		"Apache::TestReportPerl"
		"Apache::TestSmokePerl"
	)
	local failed=()
	for dep in "${MODULES[@]}"; do
		ebegin "Compile testing ${dep}"
			perl -Mblib="${S}" -M"${dep} ()" -e1
		eend $? || failed+=( "$dep" )
	done
	if [[ ${failed[@]} ]]; then
		echo
		eerror "One or more modules failed compile:";
		for dep in "${failed[@]}"; do
			eerror "  ${dep}"
		done
		die "Failing due to module compilation errors";
	fi
	perl_rm_files t/more/02testmore.t t/more/04testmore.t
	perl-module_src_test
}
pkg_postinst() {
	use test || optdep_notice
}
