# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FROM_LANG="English"
TO_LANG="Traditional Chinese (BIG5)"
DICT_PREFIX="cdict-"
DICT_SUFFIX="big5"

inherit stardict

HOMEPAGE="http://download.huzheng.org/zh_TW/"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""
