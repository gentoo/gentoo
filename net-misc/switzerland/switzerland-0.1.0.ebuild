# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 toolchain-funcs

DESCRIPTION="Network Testing Tool"
HOMEPAGE="http://www.eff.org/testyourisp/switzerland/"
SRC_URI="mirror://sourceforge/switzerland/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-libs/libpcap"
RDEPEND=${DEPEND}

src_prepare() {
	cp "${FILESDIR}"/Makefile switzerland/client

	sed -i \
		-e "s/= find_binary()/= dest/" \
		setup.py
	distutils-r1_src_prepare
}

src_compile() {
	cd switzerland/client
	emake CC=$(tc-getCC)

	cd "${S}"
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install

	dodoc BUGS.txt CREDITS

	keepdir /var/log/switzerland-pcaps
	keepdir /var/log/switzerland
}
