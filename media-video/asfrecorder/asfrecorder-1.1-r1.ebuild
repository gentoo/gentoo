# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN="${PN/asfr/ASFR}"
DESCRIPTION="Linux WindowsMedia streaming client"
HOMEPAGE="https://sourceforge.net/projects/asfrecorder/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ppc x86 ~x86-linux ~ppc-macos"

BDEPEND="app-arch/unzip"

S=${WORKDIR}/${MY_PN}

src_compile() {
	# There is a Makefile, but it only works for Cygwin, so we
	# only compile this single program.
	cd "${S}"/source || die
	$(tc-getCC) -o ${PN} ${CFLAGS} ${LDFLAGS} ${PN}.c || die "Build failed"
}

src_install () {
	# Again, no makefiles, so just take what we want.
	dobin source/${PN}
	dodoc README.TXT
}
