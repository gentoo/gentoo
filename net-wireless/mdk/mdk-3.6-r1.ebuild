# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

MY_P="${PN}${PV/./-v}"
DESCRIPTION="Wireless injection tool with various functions"
HOMEPAGE="http://homepages.tu-darmstadt.de/~p_larbig/wlan"
SRC_URI="http://homepages.tu-darmstadt.de/~p_larbig/wlan/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	eapply -p0 "${FILESDIR}"/${PV}-makefile.patch
	eapply "${FILESDIR}"/fix_wids_mdk3_v5.patch
	default
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	emake DESTDIR="${ED}" install

	insinto /usr/share/${PN}
	doins -r useful_files

	dodoc docs/* AUTHORS CHANGELOG TODO
}
