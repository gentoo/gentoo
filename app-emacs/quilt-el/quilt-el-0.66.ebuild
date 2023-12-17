# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

MY_P="quilt-${PV}"
DESCRIPTION="Quilt mode for Emacs"
HOMEPAGE="https://savannah.nongnu.org/projects/quilt
	http://satoru-takeuchi.org/dev/quilt-el/"
SRC_URI="mirror://nongnu/quilt/${MY_P}.tar.gz"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~mips ppc ppc64 ~riscv sparc x86"

RDEPEND="dev-util/quilt"

S="${WORKDIR}/${MY_P}/lib"
ELISP_PATCHES="${PN}-0.45.4-header-window.patch"
SITEFILE="50${PN}-gentoo.el"
DOCS="../doc/README.EMACS"
