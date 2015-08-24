# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="GTK+2 themes which copy and improve the look of XP Luna"
HOMEPAGE="https://art.gnome.org/themes/gtk2/1058"
#SRC_URI="https://art.gnome.org/download/themes/gtk2/1058/GTK2-EXperience.tar.gz"
SRC_URI="http://freshmeat.net/redir/${PN}/50795/url_tgz/${PN}-gtk-${PV}.tar.gz"

KEYWORDS="amd64 ~ppc sparc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="x11-themes/gtk-engines-experience"
DEPEND="${RDEPEND}
	sys-apps/findutils"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"

	mv "eXperience - ice" eXperience-ice
	mv "eXperience - olive" eXperience-olive

	# Don't install index files, since this package doesn't provide the icon
	# set. Remove cruft files also.
	find . -name 'index.theme' -o -name '*~' | xargs rm -f
}

src_compile() {
	:;
}

src_install() {
	cd "${WORKDIR}"

	for dir in eXperience* ; do
		insinto "/usr/share/themes/${dir}"
		doins -r ${dir}/*
	done

	dodoc eXperience/README
}
