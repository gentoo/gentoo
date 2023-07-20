# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="devscripts"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Perl script to check for commonly used bash features not defined by POSIX"
HOMEPAGE="https://packages.debian.org/devscripts https://salsa.debian.org/debian/devscripts"
SRC_URI="mirror://debian/pool/main/d/${MY_PN}/${MY_P/-/_}.tar.xz"
S="${WORKDIR}/${MY_PN}/scripts"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

# Requires python packages to check tools we don't need anyway
RESTRICT="test"

RDEPEND="dev-lang/perl
	virtual/perl-Getopt-Long"

src_prepare() {
	default

	sed "s@###VERSION###@${PV}@" -i checkbashisms.pl || die
}

src_compile() { :; }

src_install() {
	newbin ${PN}.pl ${PN}
	doman ${PN}.1
}
