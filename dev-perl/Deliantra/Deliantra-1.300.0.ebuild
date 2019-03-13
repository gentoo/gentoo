# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MLEHMANN
DIST_VERSION=1.30
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Deliantra suppport module to read/write archetypes, maps etc"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/AnyEvent-4.0.0
	>=dev-perl/Compress-LZF-3.110.0
	>=dev-perl/JSON-XS-2.10.0
	dev-perl/common-sense
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_test() {
	local MODULES=(
		"Deliantra ${DIST_VERSION}"
		"Deliantra::Protocol::Base 1.22"
		"Deliantra::Protocol::Constants 0.1"
		"Deliantra::Map 0.1"
		"Deliantra::Data"
		"Deliantra::MoveType"
	)
	perl_has_module "Gtk2" && MODULES+=( "Deliantra::MapWidget" )
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
	perl-module_src_test
}
