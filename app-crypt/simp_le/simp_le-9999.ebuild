# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python{2_7,3_4,3_5})

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/kuba/simp_le.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/kuba/simp_le/archive/v${PV}.tar.gz -> simp_le-${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit distutils-r1

DESCRIPTION="Simple Let's Encrypt Client"
HOMEPAGE="https://github.com/kuba/simp_le"

LICENSE="GPL-3"
SLOT="0"
IUSE="test"

RDEPEND=">=dev-python/cryptography-0.8[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.15[${PYTHON_USEDEP}]
	dev-python/pyrfc3339[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	=app-crypt/acme-0.1.0[${PYTHON_USEDEP}]
"

DEPEND="test? ( ${RDEPEND} dev-python/pylint[${PYTHON_USEDEP}] dev-python/pep8[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"
