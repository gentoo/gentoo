# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit python-single-r1

DESCRIPTION="gentoo.git signature verification tool"
HOMEPAGE="https://github.com/mgorny/gverify"
SRC_URI="https://github.com/mgorny/gverify/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	app-crypt/gnupg
	sec-keys/openpgp-keys-gentoo-auth
	dev-vcs/git"
DEPEND="${PYTHON_DEPS}"

src_compile() {
	emake PREFIX="${EPREFIX}"/usr
}

src_install() {
	emake install DESTDIR="${D}" PREFIX="${EPREFIX}"/usr
	dodoc README
}
