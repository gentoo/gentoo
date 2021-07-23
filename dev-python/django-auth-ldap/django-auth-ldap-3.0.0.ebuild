# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Django LDAP authentication backend"
HOMEPAGE="https://github.com/django-auth-ldap/django-auth-ldap
	https://pypi.org/project/django-auth-ldap/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

LICENSE="BSD-2"
SLOT="0"

RDEPEND="
	>=dev-python/django-2.2[${PYTHON_USEDEP}]
	>=dev-python/python-ldap-3.1[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		net-nds/openldap[-minimal]
	)"

distutils_enable_sphinx docs --no-autodoc

python_test() {
	# for slapd and slapdtest
	local -x SBIN=/usr/sbin:/usr/$(get_libdir)/openldap
	django-admin test -v 2 --settings tests.settings ||
		die "Tests failed with ${EPYTHON}"
}
