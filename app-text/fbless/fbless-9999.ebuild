# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="git://github.com/matimatik/fbless.git"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ncurses,xml"
inherit distutils-r1 git-2

DESCRIPTION="Python-based console fb2 reader with less-like interface"
HOMEPAGE="https://github.com/matimatik/fbless"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
