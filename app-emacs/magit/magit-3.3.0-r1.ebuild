# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A Git porcelain inside Emacs"
HOMEPAGE="https://magit.vc/
	https://github.com/magit/magit/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/magit/magit.git"
else
	SRC_URI="https://github.com/magit/magit/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
fi
S="${WORKDIR}/${P}/lisp"

LICENSE="GPL-3+"
SLOT="0"

PATCHES=( "${FILESDIR}"/${PN}-3.3.0-magit-libgit.patch )

DOCS=( ../README.md ../Documentation/AUTHORS.md ../Documentation/RelNotes )
ELISP_TEXINFO="../Documentation/*.texi"
SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	>=app-emacs/dash-2.19.1
	>=app-emacs/transient-0.3.6
	>=app-emacs/with-editor-3.0.5
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"
RDEPEND+="
	>=dev-vcs/git-2.0.0
"

src_prepare() {
	default

	echo "(setq magit-version \"${PV}\")" > magit-version.el || die
}

pkg_postinst() {
	elisp_pkg_postinst

	einfo "magit version 3.3.0 dropped necessity of the app-emacs/libegit2 package"
	einfo "magit after 3.3.0 can now use the git executable directly,"
	einfo "if you need the libegit backend, then please add app-emacs/libegit2 to @world"
}
