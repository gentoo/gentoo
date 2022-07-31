# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FROM_LANG="Russian"
TO_LANG="English"
DICT_PREFIX=""
DICT_SUFFIX="quick_rus-eng"

inherit stardict

DESCRIPTION="Quick but still useful Russian to English dictionary"
HOMEPAGE="http://download.huzheng.org/Quick/"

KEYWORDS="amd64 ~riscv x86"
