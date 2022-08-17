# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FROM_LANG="English"
TO_LANG="German"
DICT_PREFIX="dictd_www.freedict.de_"

inherit stardict

HOMEPAGE="http://download.huzheng.org/freedict.de/"

KEYWORDS="amd64 ppc ~riscv sparc x86"
