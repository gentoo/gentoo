# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
case "${PV}" in
	(9999*)
		KEYWORDS=""
		VCS_ECLASS=git-r2
		EGIT_REPO_URI="git://github.com/tomszilagyi/${PN}.git"
		EGIT_PROJECT="${PN}.git"
		;;
	(*)
		KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
		SRC_URI="https://github.com/tomszilagyi/tap-plugins/archive/v${PV}.tar.gz -> $P.tar.gz"
		;;
esac
inherit eutils toolchain-funcs ${VCS_ECLASS}
DESCRIPTION="Tom's audio processing (TAP) LADSPA plugins"
HOMEPAGE="https://github.com/tomszilagyi/tap-plugins http://tap-plugins.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"
DOCS=( README CREDITS )
PATCHES=( $FILESDIR/tap-plugins-1.0.1-makefile.patch )
src_compile() {
	emake CC=$(tc-getCC) EXTRA_LDFLAGS="${LDFLAGS}"
}

src_install() {
insinto /usr/share/ladspa/rdf
doins *.rdf

exeinto /usr/$(get_libdir)/ladspa
doexe *.so

einstalldocs
}
