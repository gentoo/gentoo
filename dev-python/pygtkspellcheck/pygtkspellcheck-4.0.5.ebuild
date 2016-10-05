# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 )
PYTHON_REQ_USE="sqlite"
inherit distutils-r1

DESCRIPTION="a simple but quite powerful spellchecking library for GTK written in pure Python"
HOMEPAGE="https://github.com/koehlma/pygtkspellcheck"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/pyenchant[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
