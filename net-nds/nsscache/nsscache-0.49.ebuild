# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10,11,12} )

inherit distutils-r1

DESCRIPTION="commandline tool to sync directory services to local cache"
HOMEPAGE="https://github.com/google/nsscache"
SRC_URI="https://github.com/google/nsscache/archive/version/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nsscache s3 test"

# testing requires local network (e.g. spin up slapd, httpd)
#PROPERTIES="test_network"
#RESTRICT="test"

# Optional extras:
# TODO: gcs? ( https://pypi.org/project/google-cloud-storage/ )
#
# Testing:
# *unit* tests do not require networking.
# *integration* tests require openldap's slapd and networking
RDEPEND="
	nsscache? ( >=sys-auth/libnss-cache-0.10 )
	>=dev-python/python-ldap-3.4[${PYTHON_USEDEP}]
	>=dev-python/pycurl-7.45.2[${PYTHON_USEDEP}]
	s3? ( dev-python/boto3[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	dev-python/packaging[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${PN}-version-${PV}"

python_prepare_all() {
	# nsscache.conf is example only, and should be installed in docs.
	# Default config tries $PREFIX/config/nsscache.conf
	sed -i \
		-e '/data_files/{s,.nsscache.conf.,,}' \
		setup.py
	# Upstream forgot to bump the version
	sed -i \
		-e '/^__version__/s,0.48,0.49,g' \
		nss_cache/__init__.py

	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile --verbose
}

python_install() {
	distutils-r1_python_install

	python_scriptinto /usr/libexec/nsscache
	python_doexe examples/authorized-keys-command.py

	# Do not install the tests as functional source.
	find "${D}" \
		-path '*/site-packages/nss_cache/*' \( \
			-iname '*_test.py*' \
			-o -iname '*_test.*.py*' \
		\) \
		-delete

	# Ignore any exit code from find.
	return 0
}

python_install_all() {
	distutils-r1_python_install_all

	doman nsscache.1 nsscache.conf.5
	dodoc THANKS *.md nsscache.conf nsscache.cron

	keepdir /var/lib/nsscache
}

distutils_enable_tests pytest
