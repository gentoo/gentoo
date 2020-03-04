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
inherit eutils multilib-minimal ${VCS_ECLASS}
DESCRIPTION="Tom's audio processing (TAP) LADSPA plugins"
HOMEPAGE="https://github.com/tomszilagyi/tap-plugins http://tap-plugins.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
DEPEND="media-libs/ladspa-sdk[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"
DOCS=( README CREDITS )
src_prepare()
{
	default
	multilib_copy_sources
}
multilib_src_configure() { :; }
multilib_src_install()
{
	emake install \
		INSTALL_PLUGINS_DIR="${ED}"/usr/$(get_libdir)/ladspa \
		INSTALL_LRDF_DIR="${ED}"/usr/share/ladspa/rdf
    einstalldocs
}
multilib_src_install_all(){
einfo "If you use only 64 bit sequencers, you may want to disable 32 bit support via USE flag"
einfo "example| media-plugins/tap-plugins -abi_x86_32"
default
}
