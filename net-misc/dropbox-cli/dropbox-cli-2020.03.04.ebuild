# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit python-r1 bash-completion-r1

DESCRIPTION="Cli interface for dropbox (python), part of nautilus-dropbox"
HOMEPAGE="https://www.dropbox.com/"
SRC_URI="https://dev.gentoo.org/~grozin/${P}.py.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="net-misc/dropbox
	${PYTHON_DEPS}
	dev-python/pygpgme[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]"

S=${WORKDIR}

src_install() {
	newbin ${P}.py ${PN}
	python_replicate_script "${D}"/usr/bin/${PN}
	newbashcomp "${FILESDIR}"/${PN}-19-completion ${PN}
}
