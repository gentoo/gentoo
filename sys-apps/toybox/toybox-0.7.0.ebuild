# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multiprocessing savedconfig toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gfto/toybox.git"
else
	SRC_URI="http://landley.net/code/toybox/downloads/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

# makefile is stupid
RESTRICT="test"

DESCRIPTION="Common linux commands in a multicall binary"
HOMEPAGE="http://landley.net/code/toybox/"

# The source code does not explicitly say that it's BSD, but the author has repeatedly said it
LICENSE="BSD-2"
SLOT="0"
IUSE=""

src_prepare() {
	epatch_user
	restore_config .config
}

src_configure() {
	if [ -f .config ]; then
		yes "" | emake -j1 oldconfig > /dev/null
		return 0
	else
		einfo "Could not locate user configfile, so we will save a default one"
		emake defconfig > /dev/null
	fi
}

src_compile() {
	tc-export CC STRIP
	export HOSTCC=$(tc-getBUILD_CC)
	unset CROSS_COMPILE
	export CPUS=$(makeopts_jobs)
	emake V=1
}

src_test() {
	emake test
}

src_install() {
	save_config .config
	newbin toybox_unstripped toybox
}
