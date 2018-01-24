# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python Application for sending sms over multiple ISPs"
HOMEPAGE="http://pysmssend.silverarrow.org/"
SRC_URI="http://pysmssend.silverarrow.org/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">dev-python/mechanize-0.1.7b[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

python_install() {
	distutils-r1_python_install
	python_doscript pysmssendcmd
	ln -s pysmssendcmd "${D}$(python_get_scriptdir)"/pysmssend || die
}

src_install() {
	distutils-r1_src_install
	dosym   pysmssendcmd /usr/bin/pysmssend
	einstalldocs
}
