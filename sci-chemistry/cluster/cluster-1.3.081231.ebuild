# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/cluster/cluster-1.3.081231.ebuild,v 1.7 2015/05/21 18:55:42 jlec Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Build lists of collections of interacting items"
HOMEPAGE="http://kinemage.biochem.duke.edu/software/index.php"
SRC_URI="http://kinemage.biochem.duke.edu/downloads/software/${PN}/${PN}.${PV}.src.tgz"

SLOT="0"
LICENSE="richardson"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}"/${PN}1.3src

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-ldflags.patch \
		"${FILESDIR}"/${PV}-includes.patch
	tc-export CXX
}

src_install() {
	dobin ${PN}
	dodoc README.cluster
}
