# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="Bump and reversion \$VERSION on release"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	>=dev-perl/Dist-Zilla-4.200.0
	>=dev-perl/Version-Next-0.2.0
"
DEPEND="
	dev-perl/Module-Build-Tiny
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"
PERL_RM_FILES=(
	"t/author-pod-syntax.t"
)
src_test() {
	local MODULES=(
		"Dist::Zilla::Plugin::ReversionOnRelease ${DIST_VERSION}"
	)
	local failed=()
	for dep in "${MODULES[@]}"; do
		ebegin "Compile testing ${dep}"
			perl -Mblib="${S}" -M"${dep} ()" -e1
		eend $? || failed+=( "${dep}" )
	done
	if [[ ${failed[@]} ]]; then
		echo
		eerror "One or more modules failed compile:";
		for dep in "${failed[@]}"; do
			eerror "  ${dep}"
		done
		die "Failing due to module compilation errors";
	fi
	# Note: Not adding plugin VersionFromModule as it requires
	# Dist-Zilla-Plugins-CJM.... which is yuuge.
	perl-module_src_test
}
