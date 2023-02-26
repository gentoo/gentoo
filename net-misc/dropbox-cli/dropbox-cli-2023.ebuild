# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit python-r1 bash-completion-r1

DESCRIPTION="Cli interface for dropbox (python), part of nautilus-dropbox"
HOMEPAGE="https://www.dropbox.com/"
SRC_URI="https://dev.gentoo.org/~grozin/${P}.py.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gpg"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="net-misc/dropbox
	${PYTHON_DEPS}
	gpg? ( app-crypt/gpgme[python] )
	dev-python/pygobject:3[${PYTHON_USEDEP}]"

S=${WORKDIR}

src_install() {
	newbin ${P}.py ${PN}
	python_replicate_script "${D}"/usr/bin/${PN}
	newbashcomp "${FILESDIR}"/${PN}-19-completion ${PN}
}
