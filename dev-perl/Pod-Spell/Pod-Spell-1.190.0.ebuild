# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=DOLMEN
DIST_VERSION=1.19
inherit perl-module

DESCRIPTION="A formatter for spellchecking Pod"
SRC_URI+=" mirror://gentoo/podspell.1.gz https://dev.gentoo.org/~tove/files/podspell.1.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="test minimal"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-Tiny
	>=dev-perl/File-ShareDir-ProjectDistDir-1.0.0
	dev-perl/Lingua-EN-Inflect
	virtual/perl-Pod-Escapes
	virtual/perl-Pod-Parser
	virtual/perl-Text-Tabs+Wrap
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? (
		!minimal? ( >=virtual/perl-CPAN-Meta-2.120.900 )
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		dev-perl/Test-Deep
		virtual/perl-Test-Simple
	)
"

src_install() {
	perl-module_src_install
	doman "${WORKDIR}"/podspell.1
}
