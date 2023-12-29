# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="extract attachment files out of a MIME-encoded email pack"
HOMEPAGE="https://pldaniels.com/ripmime/"
SRC_URI="https://www.pldaniels.com/ripmime/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.0.9-makefile.patch"
	"${FILESDIR}/${PN}-1.4.0.9-buffer-overflow.patch"
)

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		CFLAGS="${CFLAGS}" \
		default solib
}

src_install() {
	dobin ripmime
	doman ripmime.1
	dodoc CHANGELOG INSTALL README TODO

	insinto /usr/include/ripmime
	doins mime.h ripmime-api.h

	dolib.so libripmime.so.1.4.0
	dosym libripmime.so.1.4.0 /usr/$(get_libdir)/libripmime.so
	dosym libripmime.so.1.4.0 /usr/$(get_libdir)/libripmime.so.1
}
