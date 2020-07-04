# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="multishape 3d rotating dots"
HOMEPAGE="https://www.dockapps.net/wmdots"
SRC_URI="https://www.dockapps.net/download/${P/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	pushd "${WORKDIR}" || die
	eapply "${FILESDIR}"/${P}-gcc-10.patch
	popd || die

	default
	eapply "${FILESDIR}"/${P}-stringh.patch
	sed -e "s|cc|$(tc-getCC)|g" \
		-e "s|-g -O2|${CFLAGS}|g" -i Makefile || die

	#Fix compilation target
	sed -e "s|wmifs|wmdots|" -i Makefile || die

	#Honour Gentoo LDFLAGS, see bug #336982
	sed -e "s|-o wmdots|\$(LDFLAGS) -o wmdots|" -i Makefile || die
}

src_compile() {
	emake clean
	emake LIBDIR="-L/usr/$(get_libdir)"
}

src_install() {
	dobin wmdots
}
