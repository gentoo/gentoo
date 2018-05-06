# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Calculates NTLM Authentication codes"
HOMEPAGE="https://github.com/jborean93/ntlm-auth"
SRC_URI="https://github.com/jborean93/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/ordereddict[${PYTHON_USEDEP}]' python2_7)"
DEPEND="${RDEPEND}"
