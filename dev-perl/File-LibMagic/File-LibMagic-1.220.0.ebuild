# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="DROLSKY"
DIST_VERSION="1.22"

inherit perl-module

DESCRIPTION="Perl wrapper for libmagic"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-apps/file
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-XSLoader
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	dev-perl/Config-AutoConf
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
