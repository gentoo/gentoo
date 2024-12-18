# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=d8deaa5ac25bb45a2ca3a930309d6ecc74836a54
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="ncurses"

inherit bash-completion-r1 optfeature python-single-r1

DESCRIPTION="Ncurses interface for the Transmission BitTorrent client"
HOMEPAGE="https://github.com/tremc/tremc"
SRC_URI="https://github.com/tremc/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"

# Github tag tarballs include the repo with commit in the dir's name
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
