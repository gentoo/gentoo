# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=GBROWN
DIST_VERSION=0.18
inherit perl-module

DESCRIPTION="a Gtk2 widget for displaying Plain old Documentation (POD)"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	dev-perl/Gtk2
	dev-perl/IO-stringy
	virtual/perl-Pod-Parser
	virtual/perl-Pod-Simple
	dev-perl/Gtk2-Ex-Simple-List
	dev-perl/Locale-gettext"
DEPEND="${RDEPEND}"

src_test() {
	local MODULES=(
		"Gtk2::Ex::PodViewer ${DIST_VERSION}"
		"Gtk2::Ex::PodViewer::Parser"
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
