# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Objective CAML interface for Gtk+2"
HOMEPAGE="http://lablgtk.forge.ocamlcore.org"
SRC_URI="https://github.com/garrigue/lablgtk/releases/download/lablgtk2188/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception examples? ( lablgtk-examples )"
SLOT="2/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug examples glade gnomecanvas +ocamlopt opengl sourceview spell svg"

DEPEND="dev-lang/ocaml:=[ocamlopt?]
	dev-ml/camlp4:=
	x11-libs/gtk+:2
	glade? ( gnome-base/libglade )
	gnomecanvas? ( gnome-base/libgnomecanvas )
	opengl? (
		dev-ml/lablgl:=
		x11-libs/gtkglarea:2
	)
	sourceview? ( x11-libs/gtksourceview:2.0 )
	spell? ( app-text/gtkspell:2 )
	svg? ( gnome-base/librsvg:2 )"
RDEPEND="${DEPEND}"
BDEPEND="dev-ml/findlib
	virtual/pkgconfig"

DOCS=( CHANGES README CHANGES.API )

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_with svg rsvg)
		$(use_with glade)
		--without-gnomeui
		--without-panel
		$(use_with opengl gl)
		$(use_with spell gtkspell)
		--without-gtksourceview
		$(use_with sourceview gtksourceview2)
		$(use_with gnomecanvas)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	# parallel build crashes
	emake -j1 all
	if use ocamlopt; then
		emake -j1 opt
	fi
}

src_install () {
	local destdir="$(ocamlfind printconf destdir || die)"
	dodir "${destdir}/stublibs"
	export OCAMLFIND_DESTDIR=${ED}"${destdir}"
	export OCAMLPATH="${ED}${destdir}"
	export OCAMLFIND_LDCONF=ignore

	default
	rm "${ED}/usr/$(get_libdir)/ocaml/ld.conf" || die

	if use examples; then
		dodoc -r examples/
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
