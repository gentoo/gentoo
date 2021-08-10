# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=LBROCARD
DIST_VERSION=0.33
inherit perl-module

DESCRIPTION="Send Messages using Gmail"

SLOT="0"
KEYWORDS="amd64 ~mips x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Authen-SASL
	dev-perl/Email-Address
	dev-perl/Email-Send
	dev-perl/Net-SMTP-SSL
"
BDEPEND="${RDEPEND}"

PERL_RM_FILES=(
	"t/pod.t"
)
src_test() {
	local MODULES=(
		"Email::Send::Gmail ${DIST_VERSION}"
	)
	local failed=()
	for dep in "${MODULES[@]}"; do
		ebegin "Compile testing ${dep}"
			perl -Mblib="${S}/blib" -M"${dep} ()" -e1
		eend $? || failed+=( "${dep}" )
	done
	if [[ ${failed[@]} ]]; then
		echo
		eerror "One or more modules failed compile:";
		for dep in $"{failed[@]}"; do
			eerror "  ${dep}"
		done
		die "Failing due to module compliation errors";
	fi
	perl-module_src_test
}
