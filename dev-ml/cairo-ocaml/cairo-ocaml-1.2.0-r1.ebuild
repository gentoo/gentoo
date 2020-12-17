# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit findlib autotools

DESCRIPTION="Ocaml bindings for the cairo vector graphics library"
HOMEPAGE="https://www.cairographics.org/cairo-ocaml/"
SRC_URI="https://cgit.freedesktop.org/cairo-ocaml/snapshot/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="doc examples gtk pango"

RDEPEND="dev-lang/ocaml:=
	x11-libs/cairo
	gtk? ( dev-ml/lablgtk:2= )
	pango? ( x11-libs/pango )"
DEPEND="${RDEPEND}"

# 3 patches from debian and one for automagic on libsvg-cairo
PATCHES=(
	"${FILESDIR}"/0001-Add-missing-libraries-used-by-the-stubs-to-CAIRO_LIB.patch \
	"${FILESDIR}"/0002-Fix-Makefile-to-avoid-recompiling-files-in-usr.patch \
	"${FILESDIR}"/0003-Fix-FTBFS-on-bytecode-architectures.patch \
	"${FILESDIR}"/0004-no-automagic.patch
)

src_prepare() {
	default
	has_version '>=dev-lang/ocaml-4.06.0' && eapply "${FILESDIR}"/ocaml406.patch
	AT_M4DIR=support eautoreconf
}

src_configure() {
	econf \
		$(use_with gtk) \
		$(use_with pango pango-cairo) \
		--without-svg-cairo
}

src_compile() {
	emake -j1
	use doc && emake doc
}

src_install() {
	findlib_src_install
	dodoc README ChangeLog
	if use examples; then
		docinto examples
		dodoc test/*.ml
	fi
	# ocamlfind support
	cat <<-EOF > META
		name = "${PN}"
		description = "${DESCRIPTION}"
		requires = "bigarray"
		version = "${PV}"
		archive(byte) = "cairo.cma"
		archive(native) = "cairo.cmxa"
	EOF
	if use gtk; then
		cat <<-EOF >> META
			package "lablgtk2" (
				requires = "cairo lablgtk2"
				archive(byte) = "cairo_lablgtk.cma"
				archive(native) = "cairo_lablgtk.cmxa"
			)
		EOF
	fi
	if use pango; then
		cat <<-EOF >> META
			package "pango" (
				requires = "cairo"
				archive(byte) = "pango_cairo.cma"
				archive(native) = "pango_cairo.cmxa"
			)
		EOF
	fi
	insinto /usr/$(get_libdir)/ocaml/cairo
	doins META
}
