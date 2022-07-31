# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FROM_LANG="English"
TO_LANG="Simplified Chinese (GB)"
DICT_PREFIX="cdict-"
DICT_SUFFIX="gb"

inherit stardict

HOMEPAGE="http://download.huzheng.org/zh_CN/"

KEYWORDS="~amd64 ~arm ~ppc ~riscv ~sparc ~x86"
