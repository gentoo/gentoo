# Copyright 1999-2020 Gentoo Foundation
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
		KEYWORDS="amd64 ~ppc ~x86"
		SRC_URI="https://github.com/tomszilagyi/tap-plugins/archive/v${PV}.tar.gz"
		;;
esac
inherit eutils multilib-minimal ${VCS_ECLASS}

DESCRIPTION="Tom's audio processing (TAP) LADSPA plugins: contains DeEsser, Dynamics, Equalizer, Reverb, Stereo Echo, Tremolo"
HOMEPAGE="https://github.com/tomszilagyi/tap-plugins http://tap-plugins.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="media-libs/ladspa-sdk[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS=( README CREDITS )

src_prepare()
{
	epatch_user
	multilib_copy_sources
}

multilib_src_configure() { :; }
multilib_src_install()
{
	emake install \
		INSTALL_PLUGINS_DIR="${ED}"/usr/$(get_libdir)/ladspa \
		INSTALL_LRDF_DIR="${ED}"/usr/share/ladspa/rdf
}
