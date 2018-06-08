# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit elisp

DESCRIPTION="Emacs major modes for editing autoconf and autotest input"
HOMEPAGE="https://www.gnu.org/software/autoconf/autoconf.html"
SRC_URI="mirror://gnu/autoconf/autoconf-${PV}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"

SITEFILE="50${PN}-gentoo.el"
S="${WORKDIR}/autoconf-${PV}/lib/emacs"
