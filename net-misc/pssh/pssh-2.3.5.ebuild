# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1

DESCRIPTION="PSSH provides parallel versions of OpenSSH and related tools"
HOMEPAGE="https://github.com/lilydjwg/pssh"
SRC_URI="https://github.com/lilydjwg/pssh/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	!net-misc/putty
	virtual/openssh
"
DEPEND="${RDEPEND}"

# Requires ssh access to run.
RESTRICT="test"
