# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"
EGIT_REPO_URI="git://github.com/hwoarang/${PN}.git
	http://github.com/hwoarang/${PN}.git"

inherit distutils eutils git-2

DESCRIPTION="Python Application for sending sms over multiple ISPs"
HOMEPAGE="http://pysmssend.silverarrow.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="qt4"

DEPEND=">=dev-python/mechanize-0.1.9
	qt4? ( >=dev-python/PyQt4-4.3[X] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/pysmssend"

PYTHON_MODNAME="pysmssendmod"

src_prepare() {
	python_convert_shebangs -r 2 .
}

src_install() {
	distutils_src_install
	if use qt4; then
		insinto /usr/share/${PN}/Icons || die "insinto failed"
		doins   Icons/* || die "doins failed"
		doicon  Icons/pysmssend.png || die "doicon failed"
		dobin   pysmssend pysmssendcmd || die "failed to create executables"
		domenu	${PN}.desktop || die "make_desktop_entry failed"
	else
		dobin   pysmssendcmd || die "failed to create executable"
		dosym   pysmssendcmd /usr/bin/pysmssend || die "dosym failed"
	fi
	dodoc README AUTHORS TODO || die "dodoc failed"
}

pkg_postinst() {
	distutils_pkg_postinst
	elog
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
