# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/wklej/wklej-0.2.1-r1.ebuild,v 1.1 2015/01/18 23:14:57 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit python-single-r1

DESCRIPTION="A wklej.org submitter"
HOMEPAGE="http://wklej.org"
SRC_URI="http://wklej.org/m/apps/wklej-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="+vim"

DEPEND=""
RDEPEND="vim? ( app-editors/vim[python,$(python_gen_usedep 'python2*')] )"

# the vim script works is python2-only...
REQUIRED_USE="vim? ( ^^ ( $(python_gen_useflags 'python2*') ) )"

S=${WORKDIR}

src_install() {
	if use vim; then
		insinto /usr/share/vim/vimfiles/plugin
		doins ${PN}.vim
	fi

	python_doscript ${PN}
	dodoc README wklejrc
}
