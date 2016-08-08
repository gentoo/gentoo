# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=NJH
MODULE_VERSION=0.03
inherit perl-module

DESCRIPTION="Perl interface for the MusicBrainz libdiscid library"
SRC_URI+=" https://dev.gentoo.org/~tove/distfiles/${CATEGORY}/${PN}/${P}-patch.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"

RDEPEND=">=media-libs/libdiscid-0.2.2"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	virtual/pkgconfig
	test? (
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do"
PERL_RM_FILES=( t/05pod.t )

src_prepare() {
	# Quick n dirty fix but does the job.
	ebegin 'Patching lib/MusicBrainz/DiscID.pm'
	# There's a dangling non-ASCII character that causes perldoc to fail on
	# parsing the .pm and hence, fail tests. We should file a bug upstream.
	perl -i'' -npe "s/don.. specify/don't specify/g;" lib/MusicBrainz/DiscID.pm
	eend $?

	perl-module_src_prepare
}

src_install() {
	perl-module_src_install

	docinto examples
	dodoc examples/discid.pl
}
src_test() {
	perl_rm_files t/05pod.t
	perl-module_src_test
}
