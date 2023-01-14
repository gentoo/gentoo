# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit python-r1

DESCRIPTION="Statistics generator for git"
HOMEPAGE="http://gitstats.sourceforge.net/"
SRC_URI="https://github.com/gktrk/gitstats/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 ) MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	sci-visualization/gnuplot[gd]
	dev-vcs/git"
DEPEND="
	${PYTHON_DEPS}
"
BDEPEND="
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
	emake PREFIX="${ED}"/usr VERSION="${PV}" install
	doman doc/${PN}.1
	einstalldocs
	python_replicate_script "${ED}"/usr/bin/${PN}
}
