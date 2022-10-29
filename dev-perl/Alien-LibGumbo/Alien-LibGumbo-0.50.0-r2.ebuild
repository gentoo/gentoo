# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RUZ
DIST_VERSION=0.05
inherit perl-module toolchain-funcs

DESCRIPTION="Gumbo parser library"

SLOT="0"
KEYWORDS="~amd64 ~riscv"

# Alien-Build for Alien::Base
RDEPEND="
	>=dev-perl/Alien-Build-0.5.0
	>=dev-perl/File-ShareDir-1.30.0
	>=dev-perl/Path-Class-0.13.0
	dev-libs/gumbo
"
DEPEND="
	dev-libs/gumbo
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	>=dev-perl/Alien-Base-ModuleBuild-0.5.0
	>=dev-perl/Module-Build-0.420.0
"
src_configure() {
	unset LD;
	if [[ -n "${CCLD}" ]]; then
		export LD="${CCLD}"
	fi
	tc-export CC CXX
	perl-module_src_configure
}
src_compile() {
	./Build --config optimize="${CFLAGS}" build || die
}
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
