# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Command line tool to check Java packages for API compatibility"
HOMEPAGE="https://github.com/gentoo/java-apicheck/"
SRC_URI="https://github.com/gentoo/java-apicheck/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-java/japitools
	dev-java/java-config
	"

src_install() {
	dobin ${PN}
}
