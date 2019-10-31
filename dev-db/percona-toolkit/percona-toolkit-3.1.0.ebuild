# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit perl-module

DESCRIPTION="Advanced command-line tools to perform a variety of MySQL and system tasks"
HOMEPAGE="https://www.percona.com/software/mysql-tools/percona-toolkit"
SRC_URI="https://www.percona.com/downloads/${PN}/${PV}/source/tarball/${P}.tar.gz"

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

# Bug #501904 - CVE-2014-2029
# sed -i -e '/^=item --\[no\]version-check/,/^default: yes/{/^default: yes/d}' bin/*
# ^ is *-no-versioncheck.patch
PATCHES=(
	"${FILESDIR}"/${PN}-3.0.7-no-versioncheck.patch
	"${FILESDIR}"/${PN}-3.0.10-slave-delay-fix.patch
)

src_prepare() {
	default

	sed -i \
		-e "s/=> 'percona-toolkit',/=> 'Percona::Toolkit',/g" \
		Makefile.PL || die
}
