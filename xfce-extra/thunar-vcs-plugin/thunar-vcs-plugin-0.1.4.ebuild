# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit xfconf

DESCRIPTION="adds Subversion and GIT actions to the context menu of thunar"
HOMEPAGE="http://goodies.xfce.org/projects/thunar-plugins/thunar-vcs-plugin"
SRC_URI="mirror://xfce/src/thunar-plugins/${PN}/${PV%.*}/${P}.tar.bz2
	https://dev.gentoo.org/~ssuominen/${P}-el.po.bz2
	https://dev.gentoo.org/~ssuominen/${P}-eu.po.bz2
	mirror://gentoo/${P}-ru.po.bz2
	https://dev.gentoo.org/~ssuominen/${P}-ug.po.bz2
	https://dev.gentoo.org/~ssuominen/${P}-uk.po.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug +git +subversion"

RDEPEND=">=dev-libs/glib-2.18
	>=x11-libs/gtk+-2.14:2
	>=xfce-base/exo-0.6
	>=xfce-base/libxfce4util-4.8
	>=xfce-base/thunar-1.2
	git? ( dev-vcs/git )
	subversion? (
		>=dev-libs/apr-0.9.7
		>=dev-vcs/subversion-1.5
		)"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(use_enable subversion)
		$(use_enable git)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README )
}

src_prepare() {
	# This won't be required for next release anymore, thanks to the following commit:
	# http://git.xfce.org/thunar-plugins/thunar-vcs-plugin/commit/?id=e87584f7b87627a322f6e41025e5e52d65ebb4d8
	local lang
	for lang in el eu ru ug uk; do
		mv "${WORKDIR}"/${P}-${lang}.po po/${lang}.po || die
	done
	xfconf_src_prepare
}
