# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=INGY
DIST_VERSION=0.64
inherit perl-module

DESCRIPTION="Automatic installation of dependencies via CPAN from within Makefile.PL"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

# TESTS BAD. Wants to write to cpan's config on the live system
#SRC_TEST="do"

RDEPEND="dev-perl/Sort-Versions"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-no-dot-inc.patch"
	"${FILESDIR}/${P}-cpantest.patch"
)
src_compile() {
	echo "n" | perl-module_src_compile
}

src_test() {
	local MODULES=(
		"ExtUtils::AutoInstall ${DIST_VERSION}"
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
