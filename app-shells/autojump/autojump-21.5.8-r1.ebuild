# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit python-r1 python-utils-r1 vcs-snapshot

DESCRIPTION="change directory command that learns"
HOMEPAGE="http://github.com/joelthelion/autojump"
SRC_URI="https://github.com/joelthelion/${PN}/archive/release-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bash-completion python test zsh-completion"

RDEPEND="bash-completion? ( >=app-shells/bash-4 )
	python? ( ${PYTHON_DEPS} )
	zsh-completion? ( app-shells/zsh app-shells/gentoo-zsh-completions )"
DEPEND="test? ( ${PYTHON_DEPS} )"

src_prepare() {
	sed -e "s: \(/etc/profile.d\): \"${EPREFIX}\1\":" \
		-i bin/autojump.sh || die
}

src_compile() {
	true
}

src_install() {
	dobin bin/autojump

	insinto /etc/profile.d
	doins bin/${PN}.sh

	if use bash-completion ; then
		doins bin/${PN}.bash
	fi

	if use zsh-completion ; then
		doins bin/${PN}.zsh
		insinto /usr/share/zsh/site-functions
		doins bin/_j
	fi

	if use python ; then
		python_foreach_impl python_domodule tools/autojump_ipython.py

		einfo "This tool provides \"j\" for ipython, please add"
		einfo "\"import autojump_ipython\" to your ipy_user_conf.py."
	fi

	doman docs/${PN}.1
	dodoc README.md
}
