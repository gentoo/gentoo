# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit toolchain-funcs

DESCRIPTION="a dockapp cpu monitor with spinning 3d objects"
HOMEPAGE="https://www.dockapps.net/wmcube"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"
S="${WORKDIR}/${P}/wmcube"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ppc64 ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}"

DOCS=(
	"${WORKDIR}"/${P}/CHANGES
	"${WORKDIR}"/${P}/README
	)

src_prepare() {
	default

	pushd "${WORKDIR}"/${P} || die
	eapply "${FILESDIR}"/${P}-gcc-10.patch
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	einstalldocs
	doman ${PN}.1

	insinto /usr/share/${PN}
	doins "${WORKDIR}"/${P}/3D-objects/*.wmc
}
