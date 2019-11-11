# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Simplify writing short notes in emacs"
HOMEPAGE="https://www.emacswiki.org/emacs/RememberMode"
SRC_URI="https://github.com/jwiegley/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ FDL-1.2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="bbdb planner"
# tests require bibl-mode, restrict for now
RESTRICT="test"

RDEPEND="bbdb? ( app-emacs/bbdb )
	planner? ( app-emacs/planner )"
BDEPEND="${RDEPEND}
	sys-apps/texinfo"

ELISP_PATCHES="${PN}-1.9-make-elc.patch"
SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="remember.texi remember-extra.texi"
DOCS="ChangeLog* NEWS"

src_compile() {
	local EL="remember.el read-file-name.el"
	use bbdb && EL+=" remember-bbdb.el"
	use planner && EL+=" remember-planner.el remember-experimental.el"
	emake EL="${EL}"
}
