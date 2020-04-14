# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="ncurses"
inherit bash-completion-r1 python-single-r1

DESCRIPTION="Ncurses interface for the Transmission BitTorrent client"
HOMEPAGE="https://github.com/tremc/tremc"
SRC_URI="https://github.com/tremc/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="geoip"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		geoip? ( dev-python/geoip-python[${PYTHON_USEDEP}] )
	')
"

# This fixes a crash when starting that was committed after 0.9.1
PATCHES=( "${FILESDIR}/${PV}-fix-startup-crash.patch" )

# Specify a no-op src_compile so upstream's broken Makefile doesn't get used
src_compile() {
	:
}

src_install() {
	python_doscript tremc
	newbashcomp completion/bash/tremc.sh tremc
	insinto /usr/share/zsh/site-functions
	doins completion/zsh/_tremc
	doman tremc.1
	dodoc NEWS README.md
}
