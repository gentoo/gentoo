# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PLOCALES="ca cs es fr hr hu id ja ko pl pt_BR ru sv zh_CN zh_TW"

inherit eutils fdo-mime gnome2-utils l10n python-single-r1

DESCRIPTION="A GTK image viewer specifically designed to handle comic books"
HOMEPAGE="http://comix.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE="rar"

DEPEND="${PYTHON_DEPS}
	dev-python/pillow[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.12[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	rar? ( || ( app-arch/unrar app-arch/rar ) )"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	l10n_find_plocales_changes messages "" "/LC_MESSAGES/comix.po"

	epatch "${FILESDIR}/${P}-pillow.patch" #471522, https://sourceforge.net/p/comix/patches/50/

	# do not install .pyc into /usr/share
	local pythondir="$(python_get_sitedir)/comix"
	pythondir="${pythondir#${EPREFIX}/usr/}"
	sed -i -e "s:share/comix/src:${pythondir}:g" install.py || die
	python_fix_shebang mime/comicthumb src/comix.py
}

src_install() {
	dodir /usr
	"${PYTHON}" install.py install --no-mime --dir "${D}"usr || die

	insinto /usr/share/mime/packages
	doins mime/comix.xml

	insinto /etc/gconf/schemas
	doins mime/comicbook.schemas

	dobin mime/comicthumb
	dodoc ChangeLog README

	remove_locale() {
		rm -r "${ED}/usr/share/locale/"$1 || die
	}
	l10n_for_each_disabled_locale_do remove_locale
}

pkg_preinst() {
	gnome2_gconf_savelist
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_gconf_install
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
