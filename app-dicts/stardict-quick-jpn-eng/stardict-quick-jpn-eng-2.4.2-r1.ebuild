# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FROM_LANG="Japanese Romaji"
TO_LANG="English"
DICT_PREFIX="quick_"

inherit stardict

HOMEPAGE="http://download.huzheng.org/Quick/"

KEYWORDS="~amd64 ~ppc ~riscv ~sparc ~x86"
