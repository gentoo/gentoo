# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"
GNOME2_LA_PUNT="yes"

PYTHON_COMPAT=( python2_7 pypy )
PYTHON_REQ_USE='xml(+)'

inherit autotools eutils gnome2 multilib-minimal python-single-r1 virtualx

DESCRIPTION="Library to construct graphical interfaces at runtime"
HOMEPAGE="http://library.gnome.org/devel/libglade/stable/"

LICENSE="LGPL-2"
SLOT="2.0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs test tools"
REQUIRED_USE="tools? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-2.24.23:2[${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.10.0[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]
	tools? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"
RDEPEND="${RDEPEND}
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-gtklibs-20140508-r2
		!app-emulation/emul-linux-x86-gtklibs[-abi_x86_32(-)]
	)"

pkg_setup() {
	use tools && python-single-r1_pkg_setup
}

src_prepare() {
	# patch to stop make install installing the xml catalog
	# because we do it ourselves in postinst()
	epatch "${FILESDIR}"/Makefile.in.am-2.4.2-xmlcatalog.patch

	# patch to not throw a warning with gtk+-2.14 during tests, as it triggers abort
	epatch "${FILESDIR}/${PN}-2.6.3-fix_tests-page_size.patch"

	# Fails with gold due to recent changes in glib-2.32's pkg-config files
	epatch "${FILESDIR}/${P}-gold-glib-2.32.patch"

	# Needed for solaris, else gcc finds a syntax error in /usr/include/signal.h
	epatch "${FILESDIR}/${P}-enable-extensions.patch"

	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
		glade/Makefile.am glade/Makefile.in || die

	if ! use test; then
		sed 's/ tests//' -i Makefile.am Makefile.in || die "sed failed"
	fi

	gnome2_src_prepare
	AT_NOELIBTOOLIZE=yes eautoreconf
}

multilib_src_configure() {
	if ! multilib_is_native_abi || ! use tools; then
		export am_cv_pathless_PYTHON=none
	fi

	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		$(use_enable static-libs static)

	if multilib_is_native_abi; then
		ln -s "${S}"/doc/html doc/html || die
	fi
}

multilib_src_test() {
	Xemake check || die "make check failed"
}

multilib_src_install() {
	dodir /etc/xml
	gnome2_src_install
}

multilib_src_install_all() {
	local DOCS=( AUTHORS ChangeLog NEWS README )
	einstalldocs
}

pkg_postinst() {
	echo ">>> Updating XML catalog"
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"http://glade.gnome.org/glade-2.0.dtd" \
		"${EPREFIX}"/usr/share/xml/libglade/glade-2.0.dtd /etc/xml/catalog
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
	echo ">>> removing entries from the XML catalog"
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --del \
		"${EPREFIX}"/usr/share/xml/libglade/glade-2.0.dtd /etc/xml/catalog
}
