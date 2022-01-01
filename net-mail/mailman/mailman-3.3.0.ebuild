# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Already prepared for python 3.7, but not all deps are ready,
# see #691528
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Mailman -- the GNU mailing list manager"
HOMEPAGE="https://www.list.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	mirror://gentoo/${P}-importlib_resources-fix.diff.xz"

LICENSE="GPL-3+"
SLOT="0"
#KEYWORDS="~amd64 ~ppc ~x86"
KEYWORDS=""  # nothing til this is finished
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/aiosmtpd-1.1[${PYTHON_USEDEP}]
	dev-python/alembic[${PYTHON_USEDEP}]
	dev-python/atpublic[${PYTHON_USEDEP}]
	>=dev-python/authheaders-0.13.0[${PYTHON_USEDEP}]
	>=dev-python/authres-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/dnspython-1.14.0[${PYTHON_USEDEP}]
	>=dev-python/falcon-1.0.0[${PYTHON_USEDEP}]
	dev-python/flufl-bounce[${PYTHON_USEDEP}]
	>=dev-python/flufl-i18n-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/flufl-lock-3.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/importlib_resources[${PYTHON_USEDEP}]' python3_6)
	www-servers/gunicorn[${PYTHON_USEDEP}]
	dev-python/lazr-config[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.0[${PYTHON_USEDEP}]
	dev-python/passlib[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.2.3[${PYTHON_USEDEP}]
	dev-python/zope-component[${PYTHON_USEDEP}]
	dev-python/zope-configuration[${PYTHON_USEDEP}]
	dev-python/zope-event[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"

# Make it compatible with python 3.7 and 3.6, see
# https://gitlab.com/mailman/mailman/-/issues/690
PATCHES=( "${WORKDIR}/mailman-3.3.0-importlib_resources-fix.diff" )
