# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=(python{2_7,3_6})

inherit distutils-r1

DESCRIPTION="An OpenPGP/GPG key management tool for seed files and keyrings"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Gentoo-keys"
SRC_URI="https://dev.gentoo.org/~dolsen/releases/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}
	app-crypt/gnupg
	>=dev-python/pyGPG-0.2[${PYTHON_USEDEP}]
	>=dev-python/ssl-fetch-0.4[${PYTHON_USEDEP}]
	dev-python/snakeoil[${PYTHON_USEDEP}]
	>=app-crypt/gentoo-keys-201501052117
	"

python_install_all() {
	distutils-r1_python_install_all
	keepdir /var/log/gkeys
	fperms g+w /var/log/gkeys
}

pkg_preinst() {
	chgrp users "${D}"/var/log/gkeys
}

pkg_postinst() {
	einfo "This is experimental software."
	einfo "The API's it installs should be considered unstable"
	einfo "and are subject to change."
	einfo
	einfo "This version includes a new gkeys-gpg command"
	einfo "It can be used as an alternate gpg command for git"
	einfo "It will set the correct keyring to verify signed commits"
	einfo "provided the key it needs to verify against is part of the gkeys"
	einfo "keyring system.   It only works for verification, any other call "
	einfo "to it will re-direct directly to the normal gpg command."
	einfo
	einfo "Please file any enhancement requests, or bugs"
	einfo "at https://bugs.gentoo.org"
	einfo "We are also on IRC @ #gentoo-keys of the Freenode network"
	einfo
	ewarn "There may be some Python 3 compatibility issues still."
	ewarn "Please help us debug, fix and report them in Bugzilla."
}
