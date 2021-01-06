# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GNOME_TARBALL_SUFFIX="bz2"
GNOME2_LA_PUNT="yes"
GNOME2_EAUTORECONF="yes"

inherit gnome2 multilib-minimal virtualx

DESCRIPTION="Library to construct graphical interfaces at runtime"
HOMEPAGE="https://library.gnome.org/devel/libglade/stable/"

LICENSE="LGPL-2"
SLOT="2.0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-2.24.23:2[${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.10.0[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig"

src_prepare() {
	# patch to stop make install installing the xml catalog
	# because we do it ourselves in postinst()
	eapply "${FILESDIR}"/Makefile.in.am-2.4.2-xmlcatalog.patch

	# patch to not throw a warning with gtk+-2.14 during tests, as it triggers abort
	eapply "${FILESDIR}/${PN}-2.6.3-fix_tests-page_size.patch"

	# Fails with gold due to recent changes in glib-2.32's pkg-config files
	eapply "${FILESDIR}/${P}-gold-glib-2.32.patch"

	# Needed for solaris, else gcc finds a syntax error in /usr/include/signal.h
	eapply "${FILESDIR}/${P}-enable-extensions.patch"

	if ! use test; then
		sed 's/ tests//' -i Makefile.am Makefile.in || die "sed failed"
	fi

	mv configure.in configure.ac || die
	gnome2_src_prepare
}

multilib_src_configure() {
	export am_cv_pathless_PYTHON=none

	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		$(use_enable static-libs static)

	if multilib_is_native_abi; then
		ln -s "${S}"/doc/html doc/html || die
	fi
}

multilib_src_test() {
	virtx emake check || die "make check failed"
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
		"https://glade.gnome.org/glade-2.0.dtd" \
		"${EPREFIX}"/usr/share/xml/libglade/glade-2.0.dtd /etc/xml/catalog
	gnome2_pkg_postinst
}

pkg_postrm() {
	gnome2_pkg_postrm
	echo ">>> removing entries from the XML catalog"
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --del \
		"${EPREFIX}"/usr/share/xml/libglade/glade-2.0.dtd /etc/xml/catalog
}
