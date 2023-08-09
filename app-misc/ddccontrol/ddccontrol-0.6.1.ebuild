# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Control monitor parameters, like brightness, contrast, RGB color levels via DDC"
HOMEPAGE="https://github.com/ddccontrol/ddccontrol/"
SRC_URI="https://github.com/ddccontrol/ddccontrol/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc gtk nls +pci static-libs"

# Upstream doesn't seem to care about tests: failures for lack of translations,
# and no real test targets.
RESTRICT='test'

RDEPEND="app-misc/ddccontrol-db
	dev-libs/glib:2
	dev-libs/libxml2:2
	app-arch/xz-utils
	gtk? (
		dev-libs/atk
		media-libs/fontconfig
		media-libs/freetype
		media-libs/harfbuzz:=
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
		x11-libs/pango
	)
	pci? ( sys-apps/pciutils )"
DEPEND="${RDEPEND}"
BDEPEND="dev-perl/XML-Parser
	dev-util/gdbus-codegen
	dev-util/intltool
	sys-kernel/linux-headers
	doc? (
		>=app-text/docbook-xsl-stylesheets-1.65.1
		app-text/htmltidy
		>=dev-libs/libxslt-1.1.6
	)
	nls? ( sys-devel/gettext )"

src_prepare() {
	# ppc/ppc64 do not have inb/outb/ioperm
	# they also do not have (sys|asm)/io.h
	if ! use amd64 && ! use x86 ; then
		local card
		for card in sis intel810 ; do
			sed -r -i \
				-e "/${card}.Po/d" \
				-e "s~${card}[^[:space:]]*~ ~g" \
				src/ddcpci/Makefile.{am,ini} || die
		done
		sed -i \
			-e '/sis_/d' \
			-e '/i810_/d' \
			src/ddcpci/main.c || die
	fi

	default

	## Save for a rainy day or future patching
	touch config.rpath ABOUT-NLS
	eautoreconf
	intltoolize --force || die "intltoolize failed"
}

src_configure() {
	# amdadl broken, bug #527268
	econf \
		--htmldir='$(datarootdir)'/doc/${PF}/html \
		--disable-gnome-applet \
		--disable-amdadl \
		$(use_enable doc) \
		$(use_enable gtk gnome) \
		$(use_enable nls) \
		$(use_enable pci ddcpci) \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.la' -delete
}
