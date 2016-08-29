# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
EGIT_REPO_URI="git://github.com/hwoarang/${PN}.git
	https://github.com/hwoarang/${PN}.git"

inherit distutils-r1 eutils git-r3

DESCRIPTION="Python Application for sending sms over multiple ISPs"
HOMEPAGE="http://pysmssend.silverarrow.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="qt4"

DEPEND=">=dev-python/mechanize-0.1.9[${PYTHON_USEDEP}]
	qt4? ( >=dev-python/PyQt4-4.3[X,${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

python_install() {
	distutils-r1_python_install

	python_doscript pysmssendcmd
	if use qt4; then
		python_doscript pysmssend
	else
		ln -s pysmssendcmd "${D}$(python_get_scriptdir)"/pysmssend || die
	fi
}

src_install() {
	distutils-r1_src_install
	if use qt4; then
		insinto /usr/share/${PN}/Icons
		doins   Icons/*
		doicon  Icons/pysmssend.png
		domenu	${PN}.desktop
	else
		dosym   pysmssendcmd /usr/bin/pysmssend
	fi
	dodoc README AUTHORS TODO
}

pkg_postinst() {
	elog "${PN} can use dev-python/python-gnupg"
	elog "for keeping your account data encrypted"
	elog "and secured. If you want to use it,"
	elog "first install dev-python/python-gnupg using"
	elog "emerge -av dev-python/python/gnupg"
	elog "and then edit your ~/.pysmssend/config"
	elog "file and set:"
	elog
	elog "pysmssend_gpg_support=1"
	elog "pysmssend_gpg_key=<your_gpg_key_id>"
	elog
}
