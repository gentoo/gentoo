# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DOMIZIO
DIST_VERSION=1.3
inherit perl-module

DESCRIPTION="CGI::Builder and Apache2/mod_perl2 integration"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-perl/OOTools-2.21
	>=dev-perl/CGI-Builder-1.2
	www-apache/mod_perl
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-no-apache-1.patch" )

src_prepare() {
	rm "${S}/lib/Apache/CGI/Builder.pm" || die "Can't remove Apache-1 support"
	perl-module_src_prepare
}
src_test() {
	local MODULES=(
		"Apache2::CGI::Builder ${DIST_VERSION}"
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
	perl_rm_files t/test_pod_coverage.t t/test_pod.t
	perl-module_src_test
}
