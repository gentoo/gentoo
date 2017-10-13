# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_NAME=AcePerl
DIST_AUTHOR=LDS
DIST_VERSION=1.92
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Object-Oriented Access to ACEDB Databases"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="virtual/perl-Digest-MD5
	dev-perl/Cache-Cache
	dev-perl/GD
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i 's/", "1")/", "3")/' "${S}/Makefile.PL" || die "Can't patch config"
	perl-module_src_prepare
}
src_test() {
	local MODULES=(
		"Ace ${DIST_VERSION}"
		"Ace::Freesubs 1.00"
		"Ace::Graphics::Fk" # NO VERSION
		"Ace::Graphics::Glyph"
		"Ace::Graphics::Glyph::anchored_arrow"
		"Ace::Graphics::Glyph::arrow"
		"Ace::Graphics::Glyph::box"
		"Ace::Graphics::Glyph::crossbox"
		"Ace::Graphics::Glyph::dot"
		"Ace::Graphics::Glyph::ex"
		"Ace::Graphics::Glyph::graded_segments"
		"Ace::Graphics::Glyph::group"
		"Ace::Graphics::Glyph::line"
		"Ace::Graphics::Glyph::primers"
		"Ace::Graphics::Glyph::segments"
		"Ace::Graphics::Glyph::span"
		"Ace::Graphics::Glyph::toomany"
		"Ace::Graphics::Glyph::transcript"
		"Ace::Graphics::Glyph::triangle"
		"Ace::Graphics::GlyphFactory"
		"Ace::Graphics::Panel"
		"Ace::Graphics::Track"
		"Ace::Iterator 1.51"
		"Ace::Local 1.05"
		"Ace::Model 1.51"
		"Ace::Object 1.66"
		"Ace::Object::Wormbase"
		"Ace::RPC 1.00"
		"Ace::Sequence 1.51"
		"Ace::Sequence::Feature"
		"Ace::Sequence::FeatureList"
		"Ace::Sequence::GappedAlignment 1.20"
		"Ace::Sequence::Gene"
		"Ace::Sequence::Homol"
		"Ace::Sequence::Multi"
		"Ace::Sequence::Transcript"
		"Ace::SocketServer 1.01"
		"GFF::Filehandle"
# Need Ace::Browser
# 		"Ace::Browser::AceSubs ${DIST_VERSION}"
#		"Ace::Browser::GeneSubs ${DIST_VERSION}"
#		"Ace::Browser::SearchSubs ${DIST_VERSION}"
#		"Ace::Browser::SiteDefs ${DIST_VERSION}"
#		"Ace::Browser::TreeSubs ${DIST_VERSION}"
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
	if ! has "network" "${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}"; then
		ewarn "This package needs network access to run its full test suite"
		ewarn "For details, see:"
		ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-nodes/dev-perl/Ace"
	else
		perl-module_src_test
	fi
}
