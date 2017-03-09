# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Tool written archiving old email in mailboxes"
HOMEPAGE="http://archivemail.sourceforge.net/"
SRC_URI="mirror://sourceforge/archivemail/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 sparc x86"
IUSE=""

python_prepare_all() {
	# Fix tests for python-2.7
	sed -i -e 's:\(fp_archive = \)FixedGzipFile:\1gzip.GzipFile:' \
		test_archivemail || die "sed failed"

	distutils-r1_python_prepare_all
}

python_test() {
	"${S}"/test_archivemail || die "test_archivemail failed"
}

python_install() {
	distutils-r1_python_install --install-data=/usr/share
}

python_install_all() {
	distutils-r1_python_install_all
	dodoc examples/* FAQ

	mv "${D}/usr/share/share/man" "${D}/usr/share/" || die
	rm -rf "${D}/usr/share/share" || die
}
