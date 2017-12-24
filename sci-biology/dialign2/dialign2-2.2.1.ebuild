# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Multiple sequence alignment"
HOMEPAGE="http://bibiserv.techfak.uni-bielefeld.de/dialign"
SRC_URI="http://bibiserv.techfak.uni-bielefeld.de/applications/dialign/resources/downloads/dialign-${PV}-src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

S=${WORKDIR}/dialign_package
PATCHES=( "${FILESDIR}"/${PN}-2.2.1-fix-build-system.patch )

src_configure() {
	tc-export CC
	append-cppflags -I. -DCONS
}

src_compile() {
	emake -C src
}

src_install() {
	dobin src/${PN}-2
	insinto /usr/share/${PN}
	doins -r dialign2_dir/.

	cat >> "${T}"/80${PN} <<- EOF || die
		DIALIGN2_DIR="${EPREFIX}/usr/share/${PN}"
	EOF
	doenvd "${T}"/80${PN}
}
