# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/pixz/pixz-9999.ebuild,v 1.6 2013/06/10 17:23:29 zerochaos Exp $

EAPI=5

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Parallel Indexed XZ compressor"
HOMEPAGE="https://github.com/vasi/pixz"
LICENSE="BSD-2"
SLOT="0"
IUSE="static"

LIB_DEPEND=">=app-arch/libarchive-2.8:=[static-libs(+)]
	>=app-arch/xz-utils-5[static-libs(+)]"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/vasi/pixz.git"
	inherit git-2
	KEYWORDS=""
else
	SRC_URI="https://github.com/vasi/${PN}/archive/v${PV}.zip -> ${P}.zip"
	KEYWORDS="~amd64 ~arm ~x86"
	DEPEND="${DEPEND} app-text/asciidoc"
fi

src_configure() {
	use static && append-ldflags -static
}

src_compile() {
	if [[ ${PV} == "9999" ]] ; then
		emake CC="$(tc-getCC)" OPT="" all pixz.1
	else
		emake CC="$(tc-getCC)" OPT="" all
	fi
}

src_install() {
	dobin pixz
	doman pixz.1
	dodoc README TODO
}
