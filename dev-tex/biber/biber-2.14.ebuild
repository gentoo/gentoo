# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="A BibTeX replacement for users of biblatex"
HOMEPAGE="http://biblatex-biber.sourceforge.net/ https://github.com/plk/biber/"
SRC_URI="https://github.com/plk/biber/archive/v${PV}.tar.gz  -> ${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-lang/perl-5.30
	dev-perl/autovivification
	dev-perl/Business-ISBN
	dev-perl/Business-ISMN
	dev-perl/Business-ISSN
	dev-perl/Class-Accessor
	dev-perl/Data-Compare
	dev-perl/Data-Dump
	dev-perl/Data-Uniqid
	dev-perl/DateTime-Calendar-Julian
	dev-perl/DateTime-Format-Builder
	dev-perl/Encode-EUCJPASCII
	dev-perl/Encode-HanExtra
	dev-perl/Encode-JIS2K
	dev-perl/File-Slurper
	dev-perl/IPC-Run3
	dev-perl/libwww-perl[ssl]
	>=dev-perl/Lingua-Translit-0.280
	dev-perl/List-AllUtils
	dev-perl/List-MoreUtils
	dev-perl/List-MoreUtils-XS
	dev-perl/Log-Log4perl
	dev-perl/LWP-Protocol-https
	dev-perl/Mozilla-CA
	dev-perl/Parse-RecDescent
	dev-perl/PerlIO-utf8_strict
	dev-perl/Regexp-Common
	dev-perl/Sort-Key
	>=dev-perl/Text-BibTeX-0.880.0
	dev-perl/Text-CSV
	dev-perl/Text-CSV_XS
	dev-perl/Text-Roman
	dev-perl/URI
	>=dev-perl/Unicode-LineBreak-2019.1.0
	>=virtual/perl-Unicode-Normalize-1.260.0
	>=dev-perl/XML-LibXML-1.70
	dev-perl/XML-LibXML-Simple
	dev-perl/XML-LibXSLT
	dev-perl/XML-Writer
	~dev-tex/biblatex-3.14
	virtual/perl-IPC-Cmd
	>=virtual/perl-Unicode-Collate-1.270.0"
DEPEND="${RDEPEND}
	dev-perl/Config-AutoConf
	dev-perl/Module-Build
	dev-perl/ExtUtils-LibBuilder
	test? ( dev-perl/File-Which
			dev-perl/Test-Differences )"

mydoc="doc/biber.tex"
