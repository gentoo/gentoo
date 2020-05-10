# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

SRC_URI="https://github.com/CensoredUsername/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
DESCRIPTION="Ren'Py's rpyc scripts decompiler"
HOMEPAGE="https://github.com/CensoredUsername/unrpyc"
LICENSE="BSD-1 BSD"
SLOT="0"

IUSE="+module proto0 proto1 proto2"

DEPEND="module? ( dev-python/picklemagic[${PYTHON_USEDEP}] )"

src_prepare() {
	sed -i 's/unrpyc.py/unrpyc/g' README.md setup.py || die
	mv unrpyc.py unrpyc || die
	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile

	if use module; then
		local proto=1
		use proto0 && proto=0
		use proto1 && proto=1
		use proto2 && proto=2

		cd un.rpyc || die
		python_setup 'python2*'
		./compile.py -p${proto} || die
	fi
}

src_install() {
	distutils-r1_src_install

	if use module; then
		install -Dpm 0644 -t "${ED}/usr/share/${PN}" un.rpyc/un.rpyc || die
		einfo "For run-time rpyc decompiling copy ${EPREFIX}/usr/share/${PN}/un.rpyc to your game dir."
		newdoc un.rpyc/README.md README-un.rpyc.md
	fi
}
