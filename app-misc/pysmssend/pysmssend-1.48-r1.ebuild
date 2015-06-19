# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/pysmssend/pysmssend-1.48-r1.ebuild,v 1.1 2014/12/27 16:26:49 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="Python Application for sending sms over multiple ISPs"
HOMEPAGE="http://pysmssend.silverarrow.org/"
SRC_URI="http://pysmssend.silverarrow.org/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4"

DEPEND=">dev-python/mechanize-0.1.7b[${PYTHON_USEDEP}]
	qt4? ( dev-python/PyQt4[X,${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

S=${WORKDIR}

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
		make_desktop_entry pysmssend pySMSsend pysmssend \
			"Applications;Network"
	else
		dosym   pysmssendcmd /usr/bin/pysmssend
	fi
	dodoc README AUTHORS TODO
}
