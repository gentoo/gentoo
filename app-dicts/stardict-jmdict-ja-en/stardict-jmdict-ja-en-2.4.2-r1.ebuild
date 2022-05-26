# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FROM_LANG="Japanese"
TO_LANG="English"
DICT_PREFIX="jmdict-"

inherit stardict

HOMEPAGE="http://download.huzheng.org/ja/"
SRC_URI="http://download.huzheng.org/ja/${P}.tar.bz2"

LICENSE="GDLS"
KEYWORDS="~amd64 ~ppc ~riscv sparc x86"
IUSE=""
