# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Function (graph) tracer for user-space"
HOMEPAGE="https://github.com/namhyung/uftrace"
SRC_URI="https://github.com/namhyung/uftrace/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="capstone"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RESTRICT="test"

RDEPEND="
	${PYTHON_DEPS}
	sys-devel/gcc:*[cxx]
	sys-libs/ncurses:=
	virtual/libelf:=
	capstone? ( dev-libs/capstone:0= )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -e "s/ARCH/MYARCH/g" -e "/ldconfig/d" Makefile || die
}

src_configure() {
	econf $(use_with capstone)
}
