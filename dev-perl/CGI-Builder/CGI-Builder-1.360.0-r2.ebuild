# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DOMIZIO
DIST_VERSION=1.36
DIST_EXAMPLES=( "CBF_examples/*" )
inherit perl-module

DESCRIPTION="Framework to build simple or complex web-apps"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-perl/OOTools-2.21
	>=dev-perl/IO-Util-1.5
	dev-perl/CGI
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-test-cgipm.patch" )
src_test() {
	local MODULES=(
		# https://rt.cpan.org/Ticket/Display.html?id=123292
		# "Bundle::CGI::Builder::Complete ${DIST_VERSION}"
		"CGI::Builder ${DIST_VERSION}"
		"CGI::Builder::Conf"
		"CGI::Builder::Const"
		"CGI::Builder::Test"
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
	perl_rm_files t/test_pod.t t/test_pod_coverage.t
	perl-module_src_test
}
