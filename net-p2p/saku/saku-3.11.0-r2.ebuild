# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 user

DESCRIPTION="a clone of P2P anonymous BBS shinGETsu"
HOMEPAGE="http://shingetsu.info/"
SRC_URI="mirror://sourceforge/shingetsu/${P}.tar.gz"

LICENSE="BSD-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/cheetah[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup saku
	enewuser saku -1 -1 /var/run/saku saku
}

python_prepare_all() {
	sed -i -e "/^prefix/s:/usr:${EPREFIX}/usr:" file/saku.ini || die
	sed -i -e "s:root/share/doc/saku/:root/share/doc/${PF}/:" setup.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /etc/saku
	doins "${FILESDIR}"/saku.ini

	doinitd "${FILESDIR}"/saku

	diropts -o saku -g saku
	keepdir /var/log/saku
	keepdir /var/spool/saku
}
