# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9,10} )
PYTHON_REQ_USE="ncurses"

COMMIT="8b6b29163295e5cf12d9d874e80203c5906619c8"

inherit bash-completion-r1 optfeature python-single-r1

DESCRIPTION="Ncurses interface for the Transmission BitTorrent client"
HOMEPAGE="https://github.com/tremc/tremc"
SRC_URI="https://github.com/tremc/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"

S="${WORKDIR}/${PN}-${COMMIT}"

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

pkg_postinst() {
	optfeature "Extract ipv4 from ipv6 addresses" dev-python/ipy
	optfeature "Clipboard support" dev-python/pyperclip
}
