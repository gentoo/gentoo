# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib findlib

IUSE="debug examples glade gnomecanvas sourceview +ocamlopt spell svg"

DESCRIPTION="Objective CAML interface for Gtk+2"
HOMEPAGE="http://lablgtk.forge.ocamlcore.org/"
SRC_URI="https://forge.ocamlcore.org/frs/download.php/1627/${P}.tar.gz"
LICENSE="LGPL-2.1-with-linking-exception examples? ( lablgtk-examples )"

RDEPEND=">=x11-libs/gtk+-2.10:2
	<dev-lang/ocaml-4.09:=[ocamlopt?]
	svg? ( >=gnome-base/librsvg-2.2:2 )
	glade? ( >=gnome-base/libglade-2.0.1 )
	gnomecanvas? ( >=gnome-base/libgnomecanvas-2.2 )
	spell? ( app-text/gtkspell:2 )
	sourceview? ( x11-libs/gtksourceview:2.0 )
	dev-ml/camlp4:=
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

SLOT="2/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

src_configure() {
	econf $(use_enable debug) \
		$(use_with svg rsvg) \
		$(use_with glade) \
		--without-gnomeui \
		--without-panel \
		--without-gl \
		$(use_with spell gtkspell) \
		--without-gtksourceview \
		$(use_with sourceview gtksourceview2) \
		$(use_with gnomecanvas)
}

src_compile() {
	emake -j1 all
	if use ocamlopt; then
		emake -j1 opt
	fi
}

install_examples() {
	insinto /usr/share/doc/${P}/examples
	doins examples/*.ml examples/*.rgb examples/*.png examples/*.xpm

	# Install examples for optional components
	use gnomecanvas && insinto /usr/share/doc/${PF}/examples/canvas && doins examples/canvas/*.ml examples/canvas/*.png
	use svg && insinto /usr/share/doc/${PF}/examples/rsvg && doins examples/rsvg/*.ml examples/rsvg/*.svg
	use glade && insinto /usr/share/doc/${PF}/examples/glade && doins examples/glade/*.ml examples/glade/*.glade*
	use sourceview && insinto /usr/share/doc/${PF}/examples/sourceview && doins examples/sourceview/*.ml examples/sourceview/*.lang

	docompress -x /usr/share/doc/${PF}/examples
}

src_install() {
	findlib_src_preinst
	export OCAMLPATH="${OCAMLFIND_DESTDIR}"
	emake install DESTDIR="${D}"

	rm -f "${ED}/usr/$(get_libdir)/ocaml/ld.conf"

	dodoc CHANGES README CHANGES.API
	use examples && install_examples
}

pkg_postinst() {
	if use examples; then
		elog "To run the examples you can use the lablgtk2 toplevel."
		elog "e.g: lablgtk2 /usr/share/doc/${PF}/examples/testgtk.ml"
	fi
}
