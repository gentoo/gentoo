# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=${P/_/-}
MY_PV=${PV/_/-}
inherit versionator

DESCRIPTION="A makefile generation tool"
HOMEPAGE="https://premake.github.io/"
SRC_URI="https://github.com/${PN}/${PN}-core/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"

SLOT=$(get_major_version)

KEYWORDS="~amd64 ~ppc ~x86"

S="${WORKDIR}/${PN}-core-${MY_PV}"

src_compile() {
	emake -f Bootstrap.mak linux
}

src_test() {
	bin/release/premake${SLOT} test || die
}

src_install() {
	dobin bin/release/premake${SLOT}

	einstalldocs
}
