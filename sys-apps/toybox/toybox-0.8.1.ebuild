# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit multiprocessing savedconfig toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/landley/toybox.git"
else
	SRC_URI="https://landley.net/code/toybox/downloads/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

# makefile is stupid
RESTRICT="test"

DESCRIPTION="Common linux commands in a multicall binary"
HOMEPAGE="https://landley.net/code/toybox/"

LICENSE="0BSD"
SLOT="0"
IUSE=""

src_prepare() {
	default
	restore_config .config
}

src_configure() {
	tc-export CC STRIP
	export HOSTCC="$(tc-getBUILD_CC)"
	if [ -f .config ]; then
		yes "" | emake -j1 oldconfig > /dev/null
		return 0
	else
		einfo "Could not locate user configfile, so we will save a default one"
		emake -j1 defconfig > /dev/null
	fi
}

src_compile() {
	unset CROSS_COMPILE
	export CPUS=$(makeopts_jobs)
	emake V=1
}

src_test() {
	emake test
}

src_install() {
	save_config .config
	newbin generated/unstripped/toybox toybox
}
