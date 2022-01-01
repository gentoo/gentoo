# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop optfeature xdg-utils

DESCRIPTION="Feature-rich screenshot program"
HOMEPAGE="https://shutter-project.org/"
MY_COMMIT="af237e7f415a5fa20402703490c6190dc1af9b20"
SRC_URI="https://github.com/shutter-project/shutter/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	dev-lang/perl
	dev-perl/gnome2-canvas
	dev-perl/gnome2-wnck
	dev-perl/libxml-perl
	dev-perl/libwww-perl
	dev-perl/Glib-Object-Introspection
	dev-perl/Gtk2-Unique
	dev-perl/Gtk2-ImageView
	dev-perl/File-DesktopEntry
	dev-perl/File-HomeDir
	dev-perl/File-Which
	dev-perl/JSON
	dev-perl/File-Copy-Recursive
	dev-perl/File-MimeInfo
	dev-perl/Locale-gettext
	dev-perl/Net-DBus
	dev-perl/Number-Bytes-Human
	dev-perl/Proc-Simple
	dev-perl/Proc-ProcessTable
	dev-perl/Sort-Naturally
	dev-perl/WWW-Mechanize
	dev-perl/X11-Protocol
	dev-perl/XML-Simple
	virtual/imagemagick-tools[perl]
"

src_install() {
	dobin bin/shutter
	dodoc README
	domenu share/applications/shutter.desktop
	doicon share/pixmaps/shutter.png

	# Man page is broken. Reconstruct it.
	gunzip share/man/man1/shutter.1.gz || die "gunzip failed"
	doman share/man/man1/shutter.1

	insinto /usr/share
	doins -r share/shutter
	doins -r share/locale
	doins -r share/icons

	insinto /usr/share/metainfo
	doins share/appdata/shutter.appdata.xml

	# .po doesn't belong to installed system, only .mo
	rm -r "${ED}"/usr/share/shutter/resources/po || die

	find "${ED}"/usr/share/shutter/resources/system/plugins/ -type f ! -name '*.*' -exec chmod 755 {} \; \
		|| die "failed to make plugins executables"
	# shutter executes perl scripts as standalone scripts, and after that "require"s them.
	find "${ED}"/usr/share/shutter/resources/system/upload_plugins/upload -type f \
		-name "*.pm" -exec chmod 755 {} \; || die "failed to make upload plugins executables"
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update

	optfeature "writing Exif information" media-libs/exiftool
	optfeature "drawing tool" dev-perl/Goo-Canvas
	optfeature "image hostings uploading" "dev-perl/JSON-MaybeXS dev-perl/Net-OAuth dev-perl/Path-Class"
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
