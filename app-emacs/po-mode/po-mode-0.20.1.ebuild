# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Major mode for GNU gettext PO files"
HOMEPAGE="https://www.gnu.org/software/gettext/"
SRC_URI="mirror://gnu/gettext/gettext-${PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/gettext-${PV}/gettext-tools/emacs"
ELISP_REMOVE="start-po.el"
SITEFILE="50${PN}-gentoo.el"
