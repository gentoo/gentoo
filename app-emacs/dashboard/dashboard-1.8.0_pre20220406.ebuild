# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=69f98f5a89451c0881d0abb34ad57dd71616006a
NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Extensible Emacs dashboard, with sections for bookmarks, projects, agenda and more"
HOMEPAGE="https://github.com/emacs-dashboard/emacs-dashboard/"
SRC_URI="https://github.com/emacs-dashboard/emacs-${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${PN}-${H}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"  # tests not in the repository, require "Eask"

DOCS=( CHANGELOG.md README.org etc )
PATCHES=( "${FILESDIR}"/${PN}-dashboard-widgets.el-banners.patch )

ELISP_REMOVE=( .dir-locals.el )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" -i dashboard-widgets.el || die
}

src_install() {
	elisp_src_install

	insinto "${SITEETC}"/${PN}
	doins -r banners
}
