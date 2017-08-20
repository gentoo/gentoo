# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic readme.gentoo-r1 toolchain-funcs

DESCRIPTION="Original UNIX development tools"
HOMEPAGE="http://heirloom.sourceforge.net/devtools.html"
SRC_URI="http://downloads.sourceforge.net/project/heirloom/${PN}/${PV}/${P}.tar.bz2"

LICENSE="BSD BSD-4 CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x64-solaris"
IUSE=""

DEPEND="app-shells/heirloom-sh"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-solaris.patch"
	"${FILESDIR}/${P}-64-bit.patch"
	"${FILESDIR}/${P}-gcc6.patch"
)

DOC_CONTENTS="
	You may want to add /usr/5bin or /usr/ucb to \$PATH
	to enable using the apps of heirloom toolchest by default.
	Man pages are installed in /usr/share/man/5man/
	You may need to set \$MANPATH to access them.
"

src_prepare() {
	default
	sed -i \
		-e 's:^\(SHELL =\) \(.*\):\1 /bin/jsh:' \
		-e 's:^\(POSIX_SHELL =\) \(.*\):\1 /bin/sh:' \
		-e "s:^\(PREFIX=\)\(.*\):\1${EPREFIX}\2:" \
		-e "s:^\(SUSBIN=\)\(.*\):\1${EPREFIX}\2:" \
		-e "s:^\(LDFLAGS=\):\1${LDFLAGS}:" \
		-e "s:^\(CFLAGS=\)\(.*\):\1${CFLAGS}:" \
		-e 's:^\(STRIP=\)\(.*\):\1true:' \
		-e "s:^\(CXX = \)\(.*\):\1$(tc-getCXX):" \
		-e "s:^\(INSTALL=\)\(.*\):\1$(which install):" \
		./mk.config

	echo "CC=$(tc-getCC)" >> "./mk.config"
}

src_compile() {
	emake -j1
}

src_install() {
	emake ROOT="${D}" install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
