# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="elections-602214965283e69cb5127cc4cb89eef3807369ad"
DESCRIPTION="Gentoo election control data and scripts"
HOMEPAGE="https://gitweb.gentoo.org/proj/elections.git/"
SRC_URI="
	https://gitweb.gentoo.org/proj/elections.git/snapshot/${MY_P}.tar.bz2
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	dev-lang/perl
	dev-perl/Carp-Always
	virtual/perl-Data-Dumper
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	virtual/perl-Scalar-List-Utils
"

src_prepare() {
	default

	# delete obsolete, broken symlinks
	find completed -name Votify.pm -delete || die
}

src_install() {
	insinto /usr/lib/gentoo-elections
	doins -r completed countify Votify.pm
}
