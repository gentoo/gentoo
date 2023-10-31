# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emulate A Terminal, in a region, in a buffer and in Eshell"
HOMEPAGE="https://codeberg.org/akib/emacs-eat/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://codeberg.org/akib/${PN}.git"
else
	SRC_URI="https://codeberg.org/akib/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( ChangeLog NEWS README.org )
SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	>=app-emacs/compat-29.1.4.2
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"

elisp-enable-tests ert . -l eat-tests.el

src_compile() {
	rm -r terminfo || die
	emake EMACS="${EMACS}" EMACSFLAGS="${EMACSFLAGS}"

	elisp-compile term/eat.el

	elisp-make-autoload-file
}

src_install() {
	rm eat-tests.el || die
	elisp_src_install

	insinto "${SITELISP}/${PN}"
	doins -r term

	insinto "${SITEETC}/${PN}"
	doins -r integration
	doins -r terminfo

	insinto /usr/share
	doins -r terminfo

	doinfo eat.info
}
