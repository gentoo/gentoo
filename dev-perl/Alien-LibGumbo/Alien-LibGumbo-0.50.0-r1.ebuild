# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RUZ
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Gumbo parser library"

SLOT="0"
KEYWORDS="~amd64"

# Alien-Build for Alien::Base
RDEPEND="
	>=dev-perl/Alien-Build-0.5.0
	>=dev-perl/File-ShareDir-1.30.0
	>=dev-perl/Path-Class-0.13.0
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	>=dev-perl/Alien-Base-ModuleBuild-0.5.0
	>=dev-perl/Module-Build-0.420.0
"
src_test() {
	local MODULES=(
		"Alien::LibGumbo ${DIST_VERSION}"
		"Alien::LibGumbo::ConfigData"
		"Alien::LibGumbo::Install::Files"
	)
	local failed=()
	for dep in "${MODULES[@]}"; do
		ebegin "Compile testing ${dep}"
			perl -Mblib="${S}/blib" -M"${dep} ()" -e1
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
	# Currently useless
	# perl-module_src_test
}
