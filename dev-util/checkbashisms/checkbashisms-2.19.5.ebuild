# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="devscripts"
MY_P="${MY_PN}-${PV}"

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
	default

	eapply -p2 "${FILESDIR}"/${PN}-2.18.6-command-vV.patch

	sed "s@###VERSION###@${PV}@" -i checkbashisms.pl || die
}

src_compile() { :; }

src_install() {
	newbin ${PN}.pl ${PN}
	doman ${PN}.1
}
