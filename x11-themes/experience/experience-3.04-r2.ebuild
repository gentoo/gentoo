# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GTK+2 themes which copy and improve the look of XP Luna"
HOMEPAGE="https://web.archive.org/web/20130730053042/https://art.gnome.org/themes/gtk2/1058"
SRC_URI="mirror://gnome/teams/art.gnome.org/themes/gtk2/GTK2-EXperience.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="x11-themes/gtk-engines-experience"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	mv "eXperience - ice" eXperience-ice || die
	mv "eXperience - olive" eXperience-olive || die

	# Don't install index files, since this package doesn't provide the icon
	# set. Remove cruft files also.
	find . -name 'index.theme' -o -name '*~' | xargs rm || die
}

src_install() {
	for dir in eXperience* ; do
		insinto "/usr/share/themes/${dir}"
		doins -r ${dir}/.
	done

	dodoc eXperience/README
}
