# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit common-lisp-3 git-2

DESCRIPTION="A thin compatibility layer between Gray Stream Common Lisp implementations"
HOMEPAGE="https://common-lisp.net/project/trivial-gray-streams/"
EGIT_REPO_URI="git://github.com/${PN}/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="!dev-lisp/cl-${PN}"
