# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Build lists of collections of interacting items"
HOMEPAGE="http://kinemage.biochem.duke.edu/software/index.php"
SRC_URI="http://kinemage.biochem.duke.edu/downloads/software/${PN}/${PN}.${PV}.src.tgz"
S="${WORKDIR}"/${PN}1.3src

LICENSE="richardson"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"

PATCHES=(
	"${FILESDIR}"/${PV}-ldflags.patch
	"${FILESDIR}"/${PV}-includes.patch
	"${FILESDIR}"/${PV}-drop-registers.patch
)

src_configure() {
	tc-export CXX
	default
}

src_install() {
	newbin ${PN} molprobity-${PN}
	dodoc README.cluster
}
