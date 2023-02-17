# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="OpenStreetMap tile-based viewer for GNU Emacs"
HOMEPAGE="https://github.com/minad/osm/"
SRC_URI="https://github.com/minad/osm/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	>=app-editors/emacs-${NEED_EMACS}:*[jpeg,json,libxml2,png,svg]
	>=app-emacs/compat-29.1.3.4
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
