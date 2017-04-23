# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} pypy pypy3 )

inherit python-single-r1

DESCRIPTION="A wklej.org submitter"
HOMEPAGE="http://wklej.org"
SRC_URI="http://wklej.org/m/apps/wklej-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE="+vim"
# the vim script is python2-only...
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	vim? ( ^^ ( $(python_gen_useflags 'python2*') ) )"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	vim? ( app-editors/vim[python,$(python_gen_usedep 'python2*')] )"

S=${WORKDIR}

src_install() {
	if use vim; then
		insinto /usr/share/vim/vimfiles/plugin
		doins ${PN}.vim
	fi

	python_doscript ${PN}
	dodoc README wklejrc
}
