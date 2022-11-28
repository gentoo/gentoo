# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A lossless, high performance data compression library"
HOMEPAGE="https://github.com/richgel999/miniz"
SRC_URI="https://github.com/richgel999/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

DOCS=( ChangeLog.md readme.md )
