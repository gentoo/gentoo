# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit bash-completion-r1 python-r1 vcs-snapshot

DESCRIPTION="change directory command that learns"
HOMEPAGE="https://github.com/joelthelion/autojump"
SRC_URI="https://github.com/joelthelion/${PN}/archive/release-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc ~ppc64"
IUSE="python test"

# Not all tests pass. Need investigation.
RESTRICT="test"
RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="test? ( dev-python/flake8 dev-python/tox )"

src_prepare() {
	sed -e "s: \(/etc/profile.d\): \"${EPREFIX}\1\":" \
		-e "s:/usr/local/share:/usr/share:" \
		-i bin/autojump.sh || die
}

src_compile() {
	:
}

src_install() {
	dobin bin/autojump

	insinto /etc/profile.d
	doins bin/"${PN}".sh

	newbashcomp bin/"${PN}".bash "${PN}"
	insinto /usr/share/"${PN}"/
	doins bin/"${PN}.zsh"
	insinto /usr/share/zsh/site-functions
	doins bin/_j

	python_foreach_impl python_domodule bin/autojump_argparse.py bin/autojump_data.py bin/autojump_utils.py
	if use python; then
		python_foreach_impl python_domodule tools/autojump_ipython.py
		einfo 'This tool provides "j" for ipython, please add'
		einfo '"import autojump_ipython" to your ipy_user_conf.py.'
	fi

	doman docs/"${PN}.1"
	dodoc README.md
}
