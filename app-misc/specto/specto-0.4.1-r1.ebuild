# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

DESCRIPTION="watch configurable events and trigger notifications"
HOMEPAGE="http://specto.sourceforge.net/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="linguas_cs linguas_de linguas_es linguas_fr linguas_it
	linguas_pt_BR linguas_ro linguas_sv linguas_tr"

RDEPEND="dev-python/gconf-python[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/libgnome-python[${PYTHON_USEDEP}]
	dev-python/notify-python[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.10[${PYTHON_USEDEP}]"
DEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-icon-theme.patch

	sed -e "s:share/doc/specto:share/doc/${PF}:" \
		-i setup.py spectlib/util.py || die

	if [ -n "${LINGUAS}" ] ; then
		sed -e "/^i18n_languages = /s: = .*: = \"${LINGUAS}\":" \
			-i setup.py || die
	fi

	distutils-r1_src_prepare
}
