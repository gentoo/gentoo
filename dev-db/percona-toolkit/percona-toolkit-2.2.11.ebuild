# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils perl-app perl-module toolchain-funcs

DESCRIPTION="essential command-line utilities for MySQL"
HOMEPAGE="http://www.percona.com/software/percona-toolkit/"
SRC_URI="http://www.percona.com/downloads/${PN}/${PV}/${P}.tar.gz"

LICENSE="|| ( GPL-2 Artistic )"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
# Package warrants IUSE doc
IUSE=""

COMMON_DEPEND="dev-perl/DBI
	dev-perl/DBD-mysql
	virtual/perl-Time-HiRes"
RDEPEND="${COMMON_DEPEND}
	dev-perl/JSON
	dev-perl/libwww-perl
	dev-perl/Role-Tiny
	virtual/perl-File-Path
	virtual/perl-Getopt-Long
	virtual/perl-Time-Local
	virtual/perl-Digest-MD5
	virtual/perl-IO-Compress
	virtual/perl-File-Temp
	virtual/perl-File-Spec
	virtual/perl-Scalar-List-Utils
	dev-perl/TermReadKey"
DEPEND="${COMMON_DEPEND}
	virtual/perl-ExtUtils-MakeMaker"

src_prepare() {
	# bug 501904 - CVE-2014-2029
	# sed -i -e '/^=item --\[no\]version-check/,/^default: yes/{/^default: yes/d}' bin/*
	epatch "${FILESDIR}/${PN}-2.2.7-no-versioncheck.patch"
}

# Percona Toolkit does NOT contain the UDF code for Murmur/FNV any more.
src_install() {
	perl-module_src_install
	dodoc docs/percona-toolkit.pod
}
