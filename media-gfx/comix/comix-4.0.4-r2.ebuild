# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit gnome2-utils python-r1 xdg-utils

DESCRIPTION="A GTK image viewer specifically designed to handle comic books"
HOMEPAGE="http://comix.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="rar"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	rar? ( || ( app-arch/unrar app-arch/rar ) )"

pkg_setup() {
	python_setup
}

src_unpack() {
	default
	unpack "${S}"/{comix.1.gz,mime/comicthumb.1.gz}
}

src_prepare() {
	#471522, #687242, https://sourceforge.net/p/comix/patches/50/
	eapply "${FILESDIR}/${P}-pillow-r1.patch"

	# do not install .pyc/.gz into /usr/share
	local pythondir="$(python_get_sitedir)/comix"
	pythondir="${pythondir#${EPREFIX}/usr/}"
	sed -e "s:share/comix/src:${pythondir}:g" \
		-e "s:('comix.1.gz', 'share/man/man1'),::g" \
		-e "s:('mime/comicthumb.1.gz', 'share/man/man1'),::g" \
		-i install.py || die

	# "Desktop Entry" contains a deprecated value "Application"
	sed -e "s/Categories=Application;/Categories=/" \
		-i comix.desktop || die 'sed failed'

	python_fix_shebang mime/comicthumb src/comix.py

	default
}

src_install() {
	python_foreach_impl python_doscript mime/comicthumb

	"${PYTHON}" install.py install --no-mime --dir "${D}/usr" || die

	insinto "/usr/share/mime/packages"
	doins mime/comix.xml

	insinto "/etc/gconf/schemas"
	doins mime/comicbook.schemas

	dodoc ChangeLog README
	doman "${WORKDIR}"/{comix.1,comicthumb.1}
}

pkg_preinst() {
	gnome2_gconf_savelist
}

pkg_postinst() {
	gnome2_gconf_install

	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
