# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="License and header template for GNU Emacs"
HOMEPAGE="https://github.com/buzztaiki/lice-el/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/buzztaiki/${PN}.git"
else
	SRC_URI="https://github.com/buzztaiki/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

PATCHES=( "${FILESDIR}/${PN}-0.3-siteetc.patch" )

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default

	sed -i "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" lice.el || die
}

src_install() {
	elisp_src_install

	insinto "${SITEETC}/${PN}"
	doins -r template
}
