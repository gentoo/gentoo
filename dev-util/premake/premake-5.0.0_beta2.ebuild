# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PV=${PV/_/-}

DESCRIPTION="A makefile generation tool"
HOMEPAGE="https://premake.github.io"
SRC_URI="https://github.com/premake/premake-core/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-core-${MY_PV}"

LICENSE="BSD"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~ppc ~x86"

PATCHES=( "${FILESDIR}/${PN}-5.0.0-remove-hardcoded-libpath.patch" )

src_compile() {
	# bug #773505
	tc-export AR CC

	emake -f Bootstrap.mak linux
}

src_test() {
	bin/release/premake${SLOT} test || die
}

src_install() {
	dobin bin/release/premake${SLOT}

	einstalldocs
}
