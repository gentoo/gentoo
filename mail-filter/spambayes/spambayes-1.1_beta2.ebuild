# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/spambayes/spambayes-1.1_beta2.ebuild,v 1.1 2015/05/28 13:54:40 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="${P/_beta/b}"

DESCRIPTION="An anti-spam filter using on Bayesian filtering"
HOMEPAGE="http://spambayes.sourceforge.net"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz
	mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="PSF-2.2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	dev-python/bsddb3[${PYTHON_USEDEP}]
	dev-python/lockfile[${PYTHON_USEDEP}]
	dev-python/setuptools"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

python_install_all() {
	distutils-r1_python_install_all

	dodoc -r *.txt contrib utilities testtools

	newinitd "${FILESDIR}"/spambayespop3proxy.rc spambayespop3proxy

	insinto /etc
	doins "${FILESDIR}"/bayescustomize.ini

	keepdir /var/lib/spambayes
}
