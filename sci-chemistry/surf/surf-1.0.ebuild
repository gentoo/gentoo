# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="Solvent accesible Surface calculator"
HOMEPAGE="http://www.ks.uiuc.edu/"
SRC_URI="http://www.ks.uiuc.edu/Research/vmd/extsrcs/surf.tar.Z -> ${P}.tar.Z"

LICENSE="SURF"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

DEPEND="
	!www-client/surf
	sys-apps/ed
	x11-misc/makedepend"
RDEPEND=""

S=${WORKDIR}

src_prepare() {
	sed \
		-e 's:$(CC) $(CFLAGS) $(OBJS):$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS):g' \
		-i Makefile || die
}

src_compile() {
	emake depend \
		&& emake \
			CC="$(tc-getCC)" \
			OPT_CFLAGS="${CFLAGS} \$(INCLUDE)" \
			CFLAGS="${CFLAGS} \$(INCLUDE)"
}

src_install() {
	dobin ${PN}
	dodoc README
}
