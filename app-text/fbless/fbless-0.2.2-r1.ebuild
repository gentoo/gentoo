# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/fbless/fbless-0.2.2-r1.ebuild,v 1.1 2013/04/09 12:30:11 pinkbyte Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ncurses,xml"
inherit distutils-r1

DESCRIPTION="Python-based console fb2 reader with less-like interface"
HOMEPAGE="https://github.com/matimatik/fbless"
SRC_URI="mirror://github/matimatik/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
