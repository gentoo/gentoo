# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit perl-module

DESCRIPTION="Advanced command-line tools to perform a variety of MySQL and system tasks"
HOMEPAGE="https://www.percona.com/software/mysql-tools/percona-toolkit"
SRC_URI="https://www.percona.com/downloads/${PN}/${PV}/tarball/${P}.tar.gz"

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
	# Bug #501904 - CVE-2014-2029
	# sed -i -e '/^=item --\[no\]version-check/,/^default: yes/{/^default: yes/d}' bin/*
	eapply -p2 "${FILESDIR}"/${PN}-2.2.7-no-versioncheck.patch
	eapply -p1 "${FILESDIR}"/${PN}-2.2.19-fix-package-name.patch

	default
}
