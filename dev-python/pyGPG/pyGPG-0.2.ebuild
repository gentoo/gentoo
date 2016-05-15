# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=(python{2_7,3_3,3_4,3_5})

inherit distutils-r1

EGIT_REPO_URI="git://github.com/dol-sen/pyGPG.git"

DESCRIPTION="A python interface wrapper for gnupg's gpg command"
HOMEPAGE="https://github.com/dol-sen/pyGPG"
SRC_URI="https://dev.gentoo.org/~dolsen/releases/pyGPG/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
IUSE=""

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~s390 ~x86"

DEPEND=""
RDEPEND="${DEPEND}
	app-crypt/gnupg
	"

pkg_postinst() {
	einfo
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
	einfo "at https://github.com/dol-sen/pyGPG/issues"
	einfo "I am also on IRC @ #gentoo-keys of the freenode network"
	einfo
	ewarn "There may be some python 3 compatibility issues still."
	ewarn "Please help debug/fix/report them in github or bugzilla."
}
