# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cvs flag-o-matic toolchain-funcs

ECVS_AUTH="pserver"
ECVS_USER="anonymous"
ECVS_SERVER="heirloom.cvs.sourceforge.net:/cvsroot/heirloom"
ECVS_MODULE="heirloom-devtools"
ECVS_PASS=""
ECVS_CVS_OPTIONS="-dP"

DESCRIPTION="Original UNIX development tools"
HOMEPAGE="http://heirloom.sourceforge.net/devtools.html"
SRC_URI=""

LICENSE="BSD BSD-4 CDDL"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="app-shells/heirloom-sh"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {

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
}

pkg_postinst() {
	elog "You may want to add /usr/5bin or /usr/ucb to \$PATH"
	elog "to enable using the apps of heirloom toolchest by default."
	elog "Man pages are installed in /usr/share/man/5man/"
	elog "You may need to set \$MANPATH to access them."
}
