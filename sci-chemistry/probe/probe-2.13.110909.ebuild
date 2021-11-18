# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}.${PV}"

DESCRIPTION="Evaluates atomic packing within or between molecules"
HOMEPAGE="http://kinemage.biochem.duke.edu/software/probe.php"
SRC_URI="http://kinemage.biochem.duke.edu/downloads/software/probe/${MY_P}.src.zip"

LICENSE="richardson"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~x64-macos"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_P}.src"

PATCHES=( "${FILESDIR}"/${P}-as-needed.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin probe
	einstalldocs
}
