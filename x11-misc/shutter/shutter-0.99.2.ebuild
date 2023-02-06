# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop optfeature prefix xdg

DESCRIPTION="Feature-rich screenshot program"
HOMEPAGE="https://shutter-project.org/"
SRC_URI="https://github.com/shutter-project/shutter/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	dev-lang/perl
	dev-perl/Carp-Always
	dev-perl/libxml-perl
	dev-perl/libwww-perl
	dev-perl/Glib-Object-Introspection
	dev-perl/GooCanvas2
	dev-perl/GooCanvas2-CairoTypes
	dev-perl/Gtk3
	>=dev-perl/Gtk3-ImageView-10
	dev-perl/File-DesktopEntry
	dev-perl/File-HomeDir
	dev-perl/File-Which
	dev-perl/JSON
	dev-perl/File-Copy-Recursive
	dev-perl/File-MimeInfo
	dev-perl/Locale-gettext
	dev-perl/Net-DBus
	dev-perl/Number-Bytes-Human
	dev-perl/Pango
	dev-perl/Proc-Simple
	dev-perl/Proc-ProcessTable
	dev-perl/Sort-Naturally
	dev-perl/WWW-Mechanize
	dev-perl/X11-Protocol
	dev-perl/XML-Simple
	virtual/imagemagick-tools[perl]
	x11-libs/libwnck:3[introspection]
"
BDEPEND="sys-devel/gettext"

src_prepare() {
	hprefixify bin/shutter
	default
}

src_install() {
	dobin bin/shutter
	dodoc README
	domenu share/applications/shutter.desktop
	doicon share/pixmaps/shutter.png
	doman share/man/man1/shutter.1

	insinto /usr/share
	doins -r share/shutter
	doins -r share/locale
	doins -r share/icons

	insinto /usr/share/metainfo
	doins share/appdata/shutter.appdata.xml

	# .po doesn't belong to installed system, only .mo
	rm -r "${ED}"/usr/share/shutter/resources/po || die

	# shutter executes perl scripts as standalone scripts, and after that "require"s them.
	find "${ED}"/usr/share/shutter/resources/system/plugins/ -type f ! -name '*.*' -exec chmod +x {} + \
		|| die "failed to make plugins executables"
	find "${ED}"/usr/share/shutter/resources/system/upload_plugins/upload -type f \
		-name "*.pm" -exec chmod +x {} + || die "failed to make upload plugins executables"
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "writing Exif information" media-libs/exiftool
	optfeature "image hostings uploading" "dev-perl/JSON-MaybeXS dev-perl/Net-OAuth dev-perl/Path-Class"
}
