# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils autotools

DESCRIPTION="DDCControl allows control of monitor parameters via DDC"
HOMEPAGE="http://ddccontrol.sourceforge.net/"
COMMIT_ID="7c74181ed03839fb91e36c6012784cfce2ebe1a5"
MY_PV=${COMMIT_ID:-${PV}}
SRC_URI="https://github.com/ddccontrol/ddccontrol/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc gtk nls +pci static-libs"
S=${WORKDIR}/${PN}-${COMMIT_ID}

RDEPEND="app-misc/ddccontrol-db
	dev-libs/libxml2:2
	app-arch/xz-utils
	gtk? ( x11-libs/gtk+:2 )
	nls? ( sys-devel/gettext )
	pci? ( sys-apps/pciutils )"
DEPEND="${RDEPEND}
	dev-perl/XML-Parser
	dev-util/intltool
	sys-kernel/linux-headers
	doc? (
		>=app-text/docbook-xsl-stylesheets-1.65.1
		>=dev-libs/libxslt-1.1.6
		app-text/htmltidy
	)"

src_prepare() {
	sed -i 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die #467574
	sed -i '/;Application/d' src/gddccontrol/gddccontrol.desktop.in || die

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
