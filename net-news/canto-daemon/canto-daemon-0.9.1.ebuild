# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/canto-daemon/canto-daemon-0.9.1.ebuild,v 1.1 2015/05/01 06:51:05 pinkbyte Exp $

EAPI="5"

PYTHON_COMPAT=( python{3_3,3_4} )
PYTHON_REQ_USE="xml(+),threads(+)"
inherit distutils-r1 multilib

DESCRIPTION="Daemon part of Canto-NG RSS reader"
HOMEPAGE="http://codezen.org/canto-ng/"
SRC_URI="http://codezen.org/static/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/feedparser[${PYTHON_USEDEP}]"

S="${WORKDIR}/canto-next-${PV}"

python_prepare_all() {
	# Respect libdir during plugins installation
	sed -i -e "s:lib/canto:$(get_libdir)/canto:" setup.py || die

	distutils-r1_python_prepare_all
}
