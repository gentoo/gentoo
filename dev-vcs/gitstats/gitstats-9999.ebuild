# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-r1 git-r3

DESCRIPTION="Statistics generator for git"
HOMEPAGE="http://gitstats.sourceforge.net/"
SRC_URI=""
EGIT_REPO_URI="
	git://github.com/hoxu/gitstats.git
	https://github.com/hoxu/gitstats.git
"

LICENSE="|| ( GPL-2 GPL-3 ) MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	sci-visualization/gnuplot[gd]
	dev-vcs/git"
DEPEND="
	dev-lang/perl:*
"

DOCS=( doc/{AUTHOR,README,TODO.txt} )

src_prepare() {
	sed \
		-e "s:basedirs = \[binarypath, secondarypath, '/usr/share/gitstats'\]:basedirs = \['${EPREFIX}/usr/share/gitstats'\]:g" \
	-i gitstats || die "failed to fix static files path"
	default
}

src_compile() {
	emake VERSION="${PV}" man
}

src_install() {
	emake PREFIX="${ED}"usr VERSION="${PV}" install
	doman doc/${PN}.1
	einstalldocs
	python_replicate_script "${ED}"usr/bin/${PN}
}
