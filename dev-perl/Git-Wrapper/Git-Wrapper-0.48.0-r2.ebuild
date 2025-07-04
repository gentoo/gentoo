# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GENEHACK
DIST_VERSION=0.048
inherit perl-module

DESCRIPTION="Wrap git(7) command-line interface"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-vcs/git
	dev-perl/File-chdir
	dev-perl/Sort-Versions
"
BDEPEND="${RDEPEND}
	dev-perl/Devel-CheckBin
	test? (
		dev-perl/Test-Deep
		dev-perl/Test-Exception
	)
"

src_compile() {
	perl-module_src_compile
	local MODULES=(
		"Git::Wrapper ${DIST_VERSION}"
	)
	for dep in "${MODULES[@]}"; do
		perl -Mblib="${S}" -M"${dep} ()" -e1 ||
			die "Could not load ${dep}"
	done
}
