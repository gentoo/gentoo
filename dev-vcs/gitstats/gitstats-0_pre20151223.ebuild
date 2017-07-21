# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	KEYWORDS=""
	EGIT_REPO_URI="
		git://github.com/hoxu/gitstats.git
		https://github.com/hoxu/gitstats.git
	"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://dev.gentoo.org/~np-hardass/distfiles/${PN}/${P}.tar.xz"
fi

DESCRIPTION="Statistics generator for git"
HOMEPAGE="http://gitstats.sourceforge.net/"
LICENSE="|| ( GPL-2 GPL-3 ) MIT"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	sci-visualization/gnuplot[gd]
	dev-vcs/git"
DEPEND="
	${PYTHON_DEPS}
	dev-lang/perl:*
"

DOCS=( doc/{AUTHOR,README,TODO.txt} )

src_prepare() {
	sed \
		-e "s:basedirs = \[binarypath, secondarypath, '/usr/share/gitstats'\]:basedirs = \['${EPREFIX}/usr/share/gitstats'\]:g" \
	-i gitstats || die "failed to fix static files path"
	eapply "${FILESDIR}"/${P}-grep-force-text.patch
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
