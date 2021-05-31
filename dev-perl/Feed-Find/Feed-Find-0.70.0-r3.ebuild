# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BTROTT
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Syndication feed auto-discovery"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Class-ErrorHandler
	dev-perl/HTML-Parser
	dev-perl/libwww-perl
	dev-perl/URI
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Base
		dev-perl/CGI-Application-Server
		dev-perl/Test-HTTP-Server-Simple
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.07-no-dot-inc.patch"
	"${FILESDIR}/${PN}-0.07-local-network.patch"
)
PERL_RM_FILES=(
	inc/Spiffy.pm
	inc/Test/Base.pm
	inc/Test/Base/Filter.pm
	inc/Test/Builder.pm
	inc/Test/Builder/Module.pm
	inc/Test/More.pm
)
src_test() {
	local MODULES=(
		"Feed::Find ${DIST_VERSION}"
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
