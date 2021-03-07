# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=${P/_/-}

inherit versionator

DESCRIPTION="A makefile generation tool"
HOMEPAGE="https://premake.github.io/"
SRC_URI="mirror://sourceforge/premake/${MY_P}-src.zip"

LICENSE="BSD"
SLOT=$(get_major_version)
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	sed 's/$(ARCH) //g' -i build/gmake.unix/Premake4.make || die
}

src_compile() {
	emake -C build/gmake.unix/
}

src_install() {
	dobin bin/release/premake${SLOT}

	einstalldocs
}
