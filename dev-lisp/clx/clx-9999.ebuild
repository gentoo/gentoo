# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit common-lisp-3 git-2

DESCRIPTION="A fork of crhodes' fork of danb's fork of the CLX library, an X11 client for Common Lisp"
HOMEPAGE="https://github.com/sharplispers/clx http://www.cliki.net/CLX"
EGIT_REPO_URI="git://github.com/sharplispers/clx.git"

LICENSE="CLX"
SLOT="0"
IUSE=""

RDEPEND="!dev-lisp/cl-${PN}"
