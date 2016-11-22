# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR="DROLSKY"
DIST_VERSION="1.15"

inherit perl-module

DESCRIPTION="Perl wrapper for libmagic"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64 ~x86"
IUSE="test"

RDEPEND="
	sys-apps/file
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-XSLoader
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		dev-perl/Test-Fatal
	)
"

src_prepare() {
	default
	# Nuke author/release tests that will be skipped anyway.
	perl_rm_files t/author-* t/release-*
}
