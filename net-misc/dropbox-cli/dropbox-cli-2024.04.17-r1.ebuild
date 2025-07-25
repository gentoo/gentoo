# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit python-r1 bash-completion-r1

DESCRIPTION="Cli interface for dropbox (python), part of nautilus-dropbox"
HOMEPAGE="https://www.dropbox.com/"
# https://linux.dropbox.com/packages/dropbox.py
# https://www.dropbox.com/download?dl=packages/dropbox.py
# https://raw.githubusercontent.com/dropbox/nautilus-dropbox/master/dropbox.in
SRC_URI="https://dev.gentoo.org/~grozin/${P}.py.xz"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="+gpg"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	net-misc/dropbox
	gpg? ( dev-python/gpgmepy[${PYTHON_USEDEP}] )
"

src_install() {
	newbin ${P}.py ${PN}
	python_replicate_script "${D}"/usr/bin/${PN}
	newbashcomp "${FILESDIR}"/${PN}-19-completion ${PN}
}
