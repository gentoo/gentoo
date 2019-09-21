# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Framework for analyzing volatile memory"
HOMEPAGE="https://www.volatilityfoundation.org/"
SRC_URI="https://downloads.volatilityfoundation.org/releases/${PV}/${P}.zip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}-master

DEPEND="app-arch/unzip"
RDEPEND=">=dev-libs/distorm64-3[${PYTHON_USEDEP}]
	dev-libs/libpcre
	|| (
		dev-python/pycryptodome[${PYTHON_USEDEP}]
		dev-python/pycrypto[${PYTHON_USEDEP}]
	)"

src_install() {
	distutils-r1_src_install
	mkdir "${D}/usr/share/${PN}" || die
	mv "${D}/usr/contrib/plugins" "${D}/usr/share/${PN}/" || die
	rmdir --ignore-fail-on-non-empty "${D}/usr/contrib" || die
	mv "${D}/usr/tools" "${D}/usr/share/${PN}/" || die
	dosym vol.py /usr/bin/volatility
}
