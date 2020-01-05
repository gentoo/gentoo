# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=(python{2_7,3_6})

#EGIT_PROJECT="gentoo-keys.git"
EGIT_BRANCH="master"

inherit distutils-r1 git-r3

EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/gentoo-keys.git"

DESCRIPTION="An OpenPGP/GPG key management tool and python libs"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Gentoo-keys"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS=""

DEPEND=""
RDEPEND="${DEPEND}
	app-crypt/gnupg
	=dev-python/pyGPG-9999[${PYTHON_USEDEP}]
	=dev-python/ssl-fetch-9999[${PYTHON_USEDEP}]
	>=dev-python/snakeoil-0.6.5[${PYTHON_USEDEP}]
	>=app-crypt/gentoo-keys-201501052117
	"

S="${WORKDIR}/$P/gkeys"

python_prepare_all() {
	distutils-r1_python_prepare_all
	# copy these 2 into our subdir from the master level
	cp ../LICENSE ./ || die "cp LICENSE failed"
	cp ../README.md ./ || die "cp README.me failed"
	cp -R ../py2man ./ || die "cp-R py2man failed"
}

python_install_all() {
	distutils-r1_python_install_all
	keepdir /var/log/gkeys
	fperms g+w /var/log/gkeys
}

pkg_preinst() {
	chgrp users "${D}"/var/log/gkeys
}

pkg_postinst() {
	einfo
	einfo "This is experimental software."
	einfo "The API's it installs should be considered unstable"
	einfo "and are subject to change."
	einfo
	einfo "Please file any enhancement requests, or bugs"
	einfo "at https://bugs.gentoo.org"
	einfo "We are also on IRC @ #gentoo-keys of the freenode network"
	einfo
	ewarn "There may be some python 3 compatibility issues still."
	ewarn "Please help debug/fix/report them in bugzilla."
}
