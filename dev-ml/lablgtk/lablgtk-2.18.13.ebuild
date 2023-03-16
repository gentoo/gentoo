# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Objective CAML interface for Gtk+2"
HOMEPAGE="http://lablgtk.forge.ocamlcore.org"
SRC_URI="https://github.com/garrigue/lablgtk/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception examples? ( lablgtk-examples )"
SLOT="2/${PV}"
KEYWORDS="~amd64 arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug examples glade gnomecanvas +ocamlopt sourceview spell svg"

DEPEND=">=dev-lang/ocaml-4.05:=[ocamlopt?]
	dev-ml/camlp4:=
	x11-libs/gtk+:2
	glade? ( gnome-base/libglade )
	gnomecanvas? ( gnome-base/libgnomecanvas )
	sourceview? ( x11-libs/gtksourceview:2.0 )
	spell? ( app-text/gtkspell:2 )
	svg? ( gnome-base/librsvg:2 )"
RDEPEND="${DEPEND}"
BDEPEND="dev-ml/findlib
	virtual/pkgconfig"

DOCS=( CHANGES README CHANGES.API )

PATCHES=(
	"${FILESDIR}"/${PN}-2.18.12-cflags.patch
	"${FILESDIR}"/${PN}-2.18.12-Makefile.patch
	"${FILESDIR}"/${PN}-2.18.12-depend.patch
)

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_with svg rsvg)
		$(use_with glade)
		--without-gnomeui
		--without-panel
		# relies on EOL gtkglarea
		--without-gl
		$(use_with spell gtkspell)
		--without-gtksourceview
		$(use_with sourceview gtksourceview2)
		$(use_with gnomecanvas)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	# parallel build crashes
	emake -j1 all CFLAGS="${CFLAGS}"
	if use ocamlopt; then
		emake -j1 opt CFLAGS="${CFLAGS}"
	fi
}

src_install() {
	local destdir="$(ocamlfind printconf destdir || die)"
	dodir "${destdir}/stublibs"
	export OCAMLFIND_DESTDIR=${ED}"${destdir}"
	export OCAMLPATH="${ED}${destdir}"
	export OCAMLFIND_LDCONF=ignore

	default
	rm "${ED}/usr/$(get_libdir)/ocaml/ld.conf" || die
	dosym lablgtk2/liblablgtk2.a \
		/usr/$(get_libdir)/ocaml/liblablgtk2.a
	use sourceview && \
		dosym lablgtk2/liblablgtksourceview2.a \
		/usr/$(get_libdir)/ocaml/liblablgtksourceview2.a

	if use examples; then
		dodoc -r examples/
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
