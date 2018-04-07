# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RCAPUTO
DIST_VERSION=1.222
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="high-level interface to cddb/freedb protocol"

SLOT="0"
KEYWORDS="amd64 ia64 ppc sparc x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-Carp-1.260.0
	>=virtual/perl-Encode-2.510.0
	>=virtual/perl-IO-1.310.0
	>=virtual/perl-MIME-Base64-3.130.0
"
DEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		$RDEPEND
		>=virtual/perl-Scalar-List-Utils-1.290.0
		>=virtual/perl-Test-Simple-0.980.0
	)
"
optdep_installed() {
	local chr=" "
	has_version "${1}" && chr="I"
	printf '[%s] %s\n' "${chr}" "${1}";
}

optdep_notice() {
	elog "This package has support for optional features via the following packages"
	elog "which you may want to install seperately:"
	elog
	elog " - Support for submitting disc changes via email:"
	elog "   $(optdep_installed ">=dev-perl/MailTools-2.40.0")"
	elog "   $(optdep_installed ">=virtual/perl-MIME-Base64-3.130.0")"
	if use test; then
		elog
		elog "Additional tests may be performed automatically if the above packages"
		elog "are pre-installed."
	fi
}

pkg_postinst() {
	use test || optdep_notice
}

src_test() {
	optdep_notice
	local MODULES=(
		# https://rt.cpan.org/Ticket/Display.html?id=123290
		"CDDB 1.220"
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

	if has network ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		perl_rm_files t/release-pod-coverage.t t/release-pod-syntax.t t/000-report-versions.t
		perl-module_src_test
	else
		ewarn "This package needs network access to run functional tests."
		ewarn "For details, see:"
		ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/CDDB"
	fi
}
