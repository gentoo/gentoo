# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MY_PN="devscripts"
MY_P="${MY_PN}-${PV}"

inherit eutils

DESCRIPTION="Perl script to check for commonly used bash features not defined by POSIX"
HOMEPAGE="https://packages.debian.org/devscripts https://anonscm.debian.org/cgit/collab-maint/devscripts.git"
SRC_URI="mirror://debian/pool/main/d/${MY_PN}/${MY_P/-/_}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Requires python packages to check tools we don't need anyway
RESTRICT="test"

RDEPEND="dev-lang/perl
	virtual/perl-Getopt-Long
	!<dev-util/rpmdevtools-8.3-r1"

S="${WORKDIR}/${MY_P}/scripts"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.15.9-command-vV.patch
}

src_compile() { :; }

src_install() {
	newbin ${PN}.pl ${PN}
	doman ${PN}.1
}
