# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME_TARBALL_SUFFIX="bz2"
inherit gnome2 virtualx

DESCRIPTION="Text widget implementing syntax highlighting and other features"
HOMEPAGE="https://www.gnome.org/"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="2.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=x11-libs/gtk+-2.12:2
	>=dev-libs/libxml2-2.5:2
	>=dev-libs/glib-2.14:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	dev-build/gtk-doc-am
	>=dev-util/intltool-0.40
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog HACKING MAINTAINERS NEWS README )

# Patch from 3.x for bug #394925
PATCHES=( "${FILESDIR}/${P}-G_CONST_RETURN.patch" )

src_prepare() {
	gnome2_src_prepare

	# Skip broken test until upstream bug #621383 is solved
	sed -i -e "/guess-language/d" tests/test-languagemanager.c || die

	# The same for another broken test, upstream bug #631214
	sed -i -e "/get-language/d" tests/test-languagemanager.c || die
}

src_configure() {
	gnome2_src_configure --disable-glade-catalog
}

src_test() {
	virtx emake check
}

src_install() {
	gnome2_src_install

	insinto /usr/share/${PN}-2.0/language-specs
	doins "${FILESDIR}"/2.0/gentoo.lang
}
