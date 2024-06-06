# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Utility to manage SSH public keys stored in LDAP"
HOMEPAGE="https://github.com/jirutka/ssh-ldap-pubkey"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/jirutka/${PN}/${PN}.git"

	inherit git-r3
else
	SRC_URI="https://github.com/jirutka/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="schema"

RDEPEND="dev-python/docopt[${PYTHON_USEDEP}]
	>=dev-python/python-ldap-3.0[${PYTHON_USEDEP}]
	virtual/logger"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-describe[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)"

DOCS=( README.md CHANGELOG.adoc )

distutils_enable_tests pytest

python_test() {
	epytest -p pytest-describe
}

python_install_all() {
	distutils-r1_python_install_all

	if use schema; then
		insinto /etc/openldap/schema
		doins etc/openssh-lpk.schema
	fi

	local MY_DOCDIR="/usr/share/doc/${PF}/examples"
	insinto "${MY_DOCDIR}"
	doins etc/ldap.conf

	# We don't want to compress this small file to allow user
	# to diff configuration against upstream's default
	docompress -x "${MY_DOCDIR}"
}
