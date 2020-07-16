# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="
		https://github.com/cgdb/cgdb.git
		git@github.com:cgdb/cgdb.git"
else
	SRC_URI="https://github.com/cgdb/cgdb/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
fi
inherit multilib-minimal

DESCRIPTION="A curses front-end for GDB, the GNU debugger"
HOMEPAGE="http://cgdb.github.io/"
LICENSE="GPL-2"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

COMMONDEPEND="
	sys-libs/ncurses:0=
	sys-libs/readline:0="

DEPEND="${COMMONDEPEND}
	test? ( dev-util/dejagnu )"

RDEPEND="
	${COMMONDEPEND}
	sys-devel/gdb"

DOCS=( AUTHORS ChangeLog INSTALL NEWS README.md TODO )

src_prepare() {
	default
	./autogen.sh || die
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}
