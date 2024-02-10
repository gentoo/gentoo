# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="a front-end for Oracle program sqlplus with command-line editing"
HOMEPAGE="https://gitlab.com/jessp011/gqlplus"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~grobian/distfiles/gqlplus-1.16-sqlplus-handling-fixes.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x64-macos"
IUSE=""

DEPEND="sys-libs/readline:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-ncurses-tinfo.patch
	"${DISTDIR}"/${P}-sqlplus-handling-fixes.patch
)

src_prepare() {
	default

	# don't use bundled readline and old version containing it
	rm -Rf readline gqlplus-1.15 aclocal.m4 configure

	# maintainer can't seem to get versioning right
	sed -i '/^#define VERSION/s/"[^"]\+"/"'"${PV}"'"/' gqlplus.c || die
	sed -i '/^AC_INIT/s/\[[1-9.]\+\]/['"${PV}"']/' configure.ac || die

	# fix some ancientness, bug #777504
	sed -i 's/^INCLUDES=/gqlplus_CPPFLAGS=/' Makefile.am || die

	eautoreconf
}
