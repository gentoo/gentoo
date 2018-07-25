# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit flag-o-matic eutils multilib versionator toolchain-funcs

PATCHLEVEL="9"
MY_P="${P/_/-}"
DESCRIPTION="Type-inferring functional programming language descended from the ML family"
HOMEPAGE="http://www.ocaml.org/"
SRC_URI="https://github.com/ocaml/ocaml/archive/${PV/_/+}.tar.gz -> ${MY_P}.tar.gz
	mirror://gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2"

LICENSE="QPL-1.0 LGPL-2"
# Everytime ocaml is updated to a new version, everything ocaml must be rebuilt,
# so here we go with the subslot.
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="emacs flambda latex ncurses +ocamlopt spacetime X xemacs"

RDEPEND="
	sys-libs/binutils-libs:=
	ncurses? ( sys-libs/ncurses:0= )
	spacetime? ( sys-libs/libunwind:= )
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PDEPEND="emacs? ( app-emacs/ocaml-mode )
	xemacs? ( app-xemacs/ocaml )"

S="${WORKDIR}/${MY_P}"
pkg_setup() {
	# dev-lang/ocaml creates its own objects but calls gcc for linking, which will
	# results in relocations if gcc wants to create a PIE executable
	if gcc-specs-pie ; then
		append-ldflags -nopie
		ewarn "Ocaml generates its own native asm, you're using a PIE compiler"
		ewarn "We have appended -nopie to ocaml build options"
		ewarn "because linking an executable with pie while the objects are not pic will not work"
	fi
}

src_prepare() {
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/patches"
}

src_configure() {
	export LC_ALL=C
	local myconf=""

	# Causes build failures because it builds some programs with -pg,
	# bug #270920
	filter-flags -fomit-frame-pointer
	# Bug #285993
	filter-mfpmath sse

	# -ggdb3 & co makes it behave weirdly, breaks sexplib
	replace-flags -ggdb* -ggdb

	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	use ncurses || myconf="${myconf} -no-curses"
	use X || myconf="${myconf} -no-graph"
	use flambda && myconf="${myconf} -flambda"
	use spacetime && myconf="${myconf} -spacetime"

	# ocaml uses a home-brewn configure script, preventing it to use econf.
	RAW_LDFLAGS="$(raw-ldflags)" ./configure \
		--prefix "${EPREFIX}"/usr \
		--bindir "${EPREFIX}"/usr/bin \
		--target-bindir "${EPREFIX}"/usr/bin \
		--libdir "${EPREFIX}"/usr/$(get_libdir)/ocaml \
		--mandir "${EPREFIX}"/usr/share/man \
		-target "${CHOST}" \
		-host "${CBUILD}" \
		-cc "$(tc-getCC)" \
		-as "$(tc-getAS)" \
		-aspp "$(tc-getCC) -c" \
		-partialld "$(tc-getLD) -r" \
		--with-pthread ${myconf} || die "configure failed!"

	# http://caml.inria.fr/mantis/view.php?id=4698
	export CCLINKFLAGS="${LDFLAGS}"
}

src_compile() {
	emake world

	# Native code generation can be disabled now
	if use ocamlopt ; then
		# bug #279968
		emake opt
		emake -j1 opt.opt
	fi
}

src_test() {
	if use ocamlopt ; then
		emake -j1 tests
	else
		ewarn "${PN} testsuite requires ocamlopt useflag"
	fi
}

src_install() {
	emake BINDIR="${ED}"/usr/bin \
		LIBDIR="${ED}"/usr/$(get_libdir)/ocaml \
		MANDIR="${ED}"/usr/share/man \
		install

	# Symlink the headers to the right place
	dodir /usr/include
	dosym /usr/$(get_libdir)/ocaml/caml /usr/include/caml

	dodoc Changes README.adoc

	# Create and envd entry for latex input files
	if use latex ; then
		echo "TEXINPUTS=${EPREFIX}/usr/$(get_libdir)/ocaml/ocamldoc:" > "${T}"/99ocamldoc
		doenvd "${T}"/99ocamldoc
	fi

	# Install ocaml-rebuild portage set
	insinto /usr/share/portage/config/sets
	doins "${FILESDIR}/ocaml.conf"
}
