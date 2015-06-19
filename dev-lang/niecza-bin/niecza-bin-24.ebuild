# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/niecza-bin/niecza-bin-24.ebuild,v 1.4 2014/08/10 20:50:32 slyfox Exp $

EAPI=4

inherit eutils multilib

DESCRIPTION="A Perl 6 compiler targetting the CLR with an experimental focus on optimizations"
HOMEPAGE="https://github.com/sorear/niecza"

MY_PN="niecza"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://github/sorear/${MY_PN}/${MY_P}.zip"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/mono"
DEPEND="${RDEPEND}"

S=${WORKDIR}

src_configure() { :; }

src_compile() { :; }

src_install() {
	mkdir "${D}"/opt/niecza-bin -p
	cp -r "${WORKDIR}"/* "${D}"/opt/niecza-bin || die "Failed to copy"
	einfo "The binary is installed to /opt/niecza-bin/run/Niecza.exe"
}
