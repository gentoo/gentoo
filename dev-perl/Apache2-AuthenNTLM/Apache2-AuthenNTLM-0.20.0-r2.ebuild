# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SPEEVES
DIST_VERSION=0.02
inherit perl-module

DESCRIPTION="Perform Microsoft NTLM and Basic User Authentication"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/perl-MIME-Base64
	>=www-apache/mod_perl-2"
DEPEND="${RDEPEND}"

src_test() {
	local MODULES=(
		"Apache2::AuthenNTLM ${DIST_VERSION}"
		"Authen::Smb 0.96"
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
	perl-module_src_test
}
