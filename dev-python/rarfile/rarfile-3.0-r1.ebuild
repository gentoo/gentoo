# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} pypy3 )
inherit distutils-r1

DESCRIPTION="Module for RAR archive reading"
HOMEPAGE="https://github.com/markokr/rarfile"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+compressed"

RDEPEND="compressed? ( || ( app-arch/unrar app-arch/rar ) )"

distutils_enable_tests nose
