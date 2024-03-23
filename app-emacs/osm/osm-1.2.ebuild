# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="OpenStreetMap tile-based viewer for GNU Emacs"
HOMEPAGE="https://github.com/minad/osm/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/minad/${PN}.git"
else
	SRC_URI="https://github.com/minad/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

BDEPEND="
	>=app-editors/emacs-${NEED_EMACS}:*[jpeg,json,libxml2,png,svg]
	>=app-emacs/compat-29.1.4.0
"
RDEPEND="
	${BDEPEND}
	net-misc/curl[ssl]
"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
