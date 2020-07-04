# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MSTROUT
DIST_VERSION=0.171
inherit perl-module

DESCRIPTION="interface to read and modify Apache .htpasswd files"

SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-perl/Class-Accessor
	dev-perl/Crypt-PasswdMD5
	virtual/perl-Digest
	dev-perl/Digest-SHA1
	dev-perl/IO-LockedFile
	virtual/perl-Scalar-List-Utils
"
BRDEPEND="${DEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
PERL_RM_FILES=(
	"t/02pod.t"
	"t/03podcoverage.t"
)
