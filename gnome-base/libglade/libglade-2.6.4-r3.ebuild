# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GNOME_TARBALL_SUFFIX="bz2"

inherit autotools gnome.org multilib-minimal virtualx xdg

DESCRIPTION="Library to construct graphical interfaces at runtime"
HOMEPAGE="https://library.gnome.org/devel/libglade/stable/"

LICENSE="LGPL-2"
SLOT="2.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

DEPEND=">=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-2.24.23:2[${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.10.0[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# patch to stop make install installing the xml catalog
	# because we do it ourselves in postinst()
	"${FILESDIR}/Makefile.in.am-2.4.2-xmlcatalog.patch"
	# patch to not throw a warning with gtk+-2.14 during tests, as it triggers abort
	"${FILESDIR}/${PN}-2.6.3-fix_tests-page_size.patch"
	# Fails with gold due to recent changes in glib-2.32's pkg-config files
	"${FILESDIR}/${P}-gold-glib-2.32.patch"
	# Needed for solaris, else gcc finds a syntax error in /usr/include/signal.h
	"${FILESDIR}/${P}-enable-extensions.patch"
)

src_prepare() {
	default

	# Disable python2_7 support
	sed -i -e '/AM_PATH_PYTHON/d' configure.in || die
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
		glade/Makefile.am glade/Makefile.in || die

	if ! use test; then
		sed 's/ tests//' -i Makefile.am Makefile.in || die "sed failed"
	fi
	mv configure.{in,ac}

	AT_NOELIBTOOLIZE=yes eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(use_enable static-libs static)

	if multilib_is_native_abi; then
		ln -s "${S}"/doc/html doc/html || die
	fi
}

multilib_src_test() {
	virtx emake check || die "emake check failed"
}

multilib_src_install_all() {
	dodir /etc/xml
	find "${ED}" -type f -name '*.la' -delete || die
	local DOCS=( AUTHORS ChangeLog NEWS README )
	einstalldocs
}

pkg_postinst() {
	echo ">>> Updating XML catalog"
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --add "system" \
		"https://glade.gnome.org/glade-2.0.dtd" \
		"${EPREFIX}"/usr/share/xml/libglade/glade-2.0.dtd /etc/xml/catalog
	xdg_pkg_postinst
}

pkg_postrm() {
	echo ">>> removing entries from the XML catalog"
	"${EPREFIX}"/usr/bin/xmlcatalog --noout --del \
		"${EPREFIX}"/usr/share/xml/libglade/glade-2.0.dtd /etc/xml/catalog
	xdg_pkg_postrm
}
