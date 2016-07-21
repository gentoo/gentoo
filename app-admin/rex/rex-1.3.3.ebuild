# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=FERKI
MODULE_A=Rex-${PV}.tar.gz

inherit perl-module

DESCRIPTION="(R)?ex is a small script to ease the execution of remote commands"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/DBI
	dev-perl/Digest-HMAC
	dev-perl/Digest-SHA1
	dev-perl/Expect
	dev-perl/Hash-Merge
	dev-perl/IO-String
	dev-perl/IO-Tty
	dev-perl/IPC-Shareable
	dev-perl/JSON-XS
	dev-perl/List-MoreUtils
	dev-perl/Net-OpenSSH
	dev-perl/Net-SFTP-Foreign
	dev-perl/Parallel-ForkManager
	dev-perl/Sort-Naturally
	dev-perl/String-Escape
	dev-perl/TermReadKey
	dev-perl/Text-Glob
	dev-perl/URI
	dev-perl/XML-LibXML
	dev-perl/XML-Simple
	dev-perl/libwww-perl
	dev-perl/YAML
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Digest-MD5
	virtual/perl-Exporter
	virtual/perl-File-Spec
	virtual/perl-MIME-Base64
	virtual/perl-Scalar-List-Utils
	virtual/perl-Storable
	virtual/perl-Time-HiRes
"

DEPEND="
	${RDEPEND}
	test? (
		dev-perl/Test-UseAllModules
		virtual/perl-File-Temp
	)
"

SRC_TEST="do"

S="${WORKDIR}/Rex-${PV}"
