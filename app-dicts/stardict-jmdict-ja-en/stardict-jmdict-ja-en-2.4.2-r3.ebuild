# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FROM_LANG="Japanese"
TO_LANG="English"
DICT_PREFIX="jmdict-"

inherit stardict

HOMEPAGE="http://download.huzheng.org/ja"
SRC_URI="http://download.huzheng.org/ja/${P}.tar.bz2"

LICENSE="CC-BY-SA-3.0 CC-BY-SA-4.0"
KEYWORDS="~amd64 ~ppc ~riscv ~sparc ~x86"
