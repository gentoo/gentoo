# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils savedconfig toolchain-funcs

# makefile is stupid
RESTRICT="test"

DESCRIPTION="Common linux commands in a multicall binary"
HOMEPAGE="http://landley.net/code/toybox/"
SRC_URI="http://landley.net/code/toybox/downloads/${P}.tar.bz2"

# The source code does not explicitly say that it's BSD, but the author has repeatedly said it
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

src_prepare() {
	sed -i -e 's/LOCALE/LC_ALL/' scripts/make.sh || die
	restore_config .config
	export CC="$(tc-getCC)"
	export HOSTCC="$(tc-getCC)"
}

src_configure() {
	if [ -f .config ]; then
		yes "" | emake -j1 oldconfig > /dev/null
		return 0
	else
		ewarn "Could not locate user configfile, so we will save a default one"
		emake defconfig > /dev/null
	fi
}

src_compile() {
	emake toybox_unstripped V=1
}

src_test() {
	emake test
}

src_install() {
	save_config .config
	newbin toybox_unstripped toybox
}
