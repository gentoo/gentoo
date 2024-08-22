# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..13} )

RESTRICT="test" # missing azure sdk

inherit distutils-r1

DESCRIPTION="Administration tool for disaster recovery of PostgreSQL servers"
HOMEPAGE="https://www.pgbarman.org https://sourceforge.net/projects/pgbarman/"
SRC_URI="https://github.com/2ndquadrant-it/barman/archive/release/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-release-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/boto3[${PYTHON_USEDEP}]
	dev-python/argh[${PYTHON_USEDEP}]
	dev-python/psycopg:2[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/argcomplete[${PYTHON_USEDEP}]
	net-misc/rsync
	dev-db/postgresql[server]
"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/python-snappy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	default

	sed -i -e \
		"s/^    def test_xlog_segment_mask(.*:/    @pytest.mark.xfail(reason='Test fails on Gentoo')\n\0/" \
		tests/test_xlog.py || die
}
