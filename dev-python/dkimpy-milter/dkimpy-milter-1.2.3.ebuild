# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Domain Keys Identified Mail (DKIM) signing/verifying milter for Postfix/Sendmail"
HOMEPAGE="
	https://launchpad.net/dkimpy-milter/
	https://pypi.org/project/dkimpy-milter/
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	acct-user/dkimpy-milter
	acct-group/dkimpy-milter
	dev-python/dkimpy[${PYTHON_USEDEP}]
	dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/pymilter[${PYTHON_USEDEP}]
	dev-python/authres[${PYTHON_USEDEP}]
	dev-python/pynacl[${PYTHON_USEDEP}]
	dev-python/dnspython[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-pidfile.patch"
)

python_configure() {
	esetup.py expand \
		--bindir=/usr/bin \
		--sbindir=/usr/sbin \
		--sysconfigdir=/etc
}

python_install() {
	distutils-r1_python_install

	mv "${ED}"{/usr/etc,} || die
	rm "${ED}"/etc/init.d/dkimpy-milter{.openrc,} || die
	newinitd "${FILESDIR}"/dkimpy-milter.initd dkimpy-milter
}
