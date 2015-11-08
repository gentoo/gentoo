# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Manages Maven symlinks"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2.8
	!<dev-java/maven-bin-2.0.10-r1:2.1
	!app-eselect/eselect-java"
PDEPEND="
|| (
	dev-java/maven-bin:3.1
	dev-java/maven-bin:3.2
	dev-java/maven-bin:3.3
)"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${FILESDIR}/maven-${PV}.eselect" maven.eselect \
		|| die "newins failed"
}
