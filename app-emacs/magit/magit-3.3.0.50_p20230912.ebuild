# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A Git porcelain inside Emacs"
HOMEPAGE="https://magit.vc/
	https://github.com/magit/magit/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/magit/magit.git"
	S="${WORKDIR}/${P}/lisp"
else
	[[ ${PV} == *_p20230912 ]] && COMMIT=141dd46798e5cae57617e941418ebbb3a2172f5e

	SRC_URI="https://github.com/magit/magit/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}/lisp"

	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="libgit"

DOCS=( ../README.md ../docs/AUTHORS.md ../docs/RelNotes )
ELISP_TEXINFO="../docs/*.texi"
SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	>=app-emacs/dash-2.19.1
	>=app-emacs/transient-0.3.6
	>=app-emacs/with-editor-3.0.5
	libgit? ( app-emacs/libegit2 )
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
	use libgit || rm magit-libgit.el || die
	echo "(setq magit-version \"${PV}\")" > magit-version.el || die
}

pkg_postinst() {
	elisp_pkg_postinst

	if ! use libgit; then
		einfo "The dependency on app-emacs/libegit2 is optional"
		einfo "since magit version 3.3.0. Enable the \"libgit\" flag"
		einfo "if you need the libgit backend."
	fi
}
