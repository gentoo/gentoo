# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="elections-20e84ba8cc3b328fccdc15219540443315ef4c20"
DESCRIPTION="Gentoo election control data and scripts"
HOMEPAGE="https://gitweb.gentoo.org/proj/elections.git/"
SRC_URI="https://gitweb.gentoo.org/proj/elections.git/snapshot/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-lang/perl
	dev-perl/Carp-Always
	virtual/perl-Data-Dumper
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	virtual/perl-Scalar-List-Utils"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default

	# delete obsolete, broken symlinks
	find completed -name Votify.pm -delete || die
}

src_install() {
	insinto /usr/lib/gentoo-elections
	doins -r completed countify Votify.pm
}
