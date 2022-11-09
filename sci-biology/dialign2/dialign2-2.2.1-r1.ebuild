# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Multiple sequence alignment"
HOMEPAGE="http://bibiserv.techfak.uni-bielefeld.de/dialign"
SRC_URI="http://bibiserv.techfak.uni-bielefeld.de/applications/dialign/resources/downloads/dialign-${PV}-src.tar.gz"
S="${WORKDIR}/dialign_package"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.1-fix-build-system.patch
	"${FILESDIR}"/${PN}-2.2.1-Wimplicit.patch
)

src_configure() {
	tc-export CC
}

src_compile() {
	emake -C src
}

src_install() {
	dobin src/dialign2-2

	insinto /usr/share/dialign2
	doins -r dialign2_dir/.

	newenvd - 80dialign2 <<- EOF
		DIALIGN2_DIR="${EPREFIX}/usr/share/dialign2"
	EOF
}
