# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
PYTHON_DEPEND="2:2.6"
inherit autotools git-2 python

DESCRIPTION="a tool to track the history and make backups of your home directory"
HOMEPAGE="http://jean-francois.richard.name/ghh/"
EGIT_REPO_URI="git://github.com/jfrichard/git-home-history.git
	https://github.com/jfrichard/git-home-history.git"
EGIT_BOOTSTRAP="autogen.sh"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
DOCS=( AUTHORS ChangeLog MAINTAINERS NEWS README TODO )

# probably needs more/less crap listed here ...
RDEPEND="x11-libs/gtk+:2
	dev-libs/glib:2
	gnome-base/libgnome
	app-text/gnome-doc-utils
	>=app-text/asciidoc-8
	dev-python/pygtk:2
	dev-vcs/git"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	NOCONFIGURE=yes git_src_prepare
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc ${DOCS[@]}
	python_convert_shebangs -r 2 "${ED}"
}
