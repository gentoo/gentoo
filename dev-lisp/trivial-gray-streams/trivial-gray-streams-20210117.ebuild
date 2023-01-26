# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit common-lisp-3 git-r3

DESCRIPTION="A thin compatibility layer between Gray Stream Common Lisp implementations"
HOMEPAGE="https://common-lisp.net/project/trivial-gray-streams/"
EGIT_REPO_URI="https://github.com/${PN}/${PN}"

LICENSE="MIT"
SLOT="0"

RDEPEND="!dev-lisp/cl-${PN}"
