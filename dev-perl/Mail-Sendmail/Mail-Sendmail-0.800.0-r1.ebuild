# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=0.80
inherit perl-module

DESCRIPTION="Simple platform independent mailer"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"

RDEPEND="
	virtual/perl-Digest-MD5
	virtual/perl-Exporter
	virtual/perl-MIME-Base64
	virtual/perl-Socket
	virtual/perl-Time-Local
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

src_test() {
	local MODULES=(
		"Mail::Sendmail ${DIST_VERSION}"
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
		perl-module_src_test
	else
		ewarn "Network tests disabled without DIST_TEST_OVERRIDE=~network"
	fi
}
