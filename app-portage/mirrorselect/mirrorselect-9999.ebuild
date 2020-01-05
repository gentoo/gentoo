# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="xml"

inherit eutils distutils-r1 git-r3 prefix

EGIT_REPO_URI="git://anongit.gentoo.org/proj/mirrorselect.git"

DESCRIPTION="Tool to help select distfiles mirrors for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Mirrorselect"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS=""

RDEPEND="
	dev-util/dialog
	>=net-analyzer/netselect-0.4[ipv6(+)]
	=dev-python/ssl-fetch-9999[${PYTHON_USEDEP}]
	"

python_prepare_all()  {
	python_setup
	eprefixify setup.py mirrorselect/main.py
	echo Now setting version... VERSION="9999-${EGIT_VERSION}" "${PYTHON}" setup.py set_version
	VERSION="9999-${EGIT_VERSION}" "${PYTHON}" setup.py set_version || die "setup.py set_version failed"
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test || die "tests failed under ${EPYTHON}"
}

pkg_postinst() {
	distutils-r1_pkg_postinst

	einfo "This is a development version."
	einfo "Please report any bugs you encounter to:"
	einfo "https://bugs.gentoo.org/"
}
