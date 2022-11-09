# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit common-lisp-3

DESCRIPTION="UIOP is a portability layer spun off ASDF3"
HOMEPAGE="http://common-lisp.net/project/asdf/"
SRC_URI="http://common-lisp.net/project/asdf/archives/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"

RDEPEND="~dev-lisp/asdf-${PV}"
