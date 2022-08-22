# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FROM_LANG="English"
TO_LANG="Simplified Chinese (GB)"
DICT_PREFIX="oxford-"
DICT_SUFFIX="gb"

inherit stardict

HOMEPAGE="http://download.huzheng.org/zh_CN/"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~riscv ~sparc ~x86"
