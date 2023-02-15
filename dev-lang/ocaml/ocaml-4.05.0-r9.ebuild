# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

PATCHLEVEL="9"
MY_P="${P/_/-}"
DESCRIPTION="Type-inferring functional programming language descended from the ML family"
HOMEPAGE="https://ocaml.org"
SRC_URI="https://github.com/ocaml/ocaml/archive/${PV/_/+}.tar.gz -> ${MY_P}.tar.gz
	mirror://gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-patches-1.tar.bz2"

LICENSE="QPL-1.0 LGPL-2"
# Everytime ocaml is updated to a new version, everything ocaml must be rebuilt,
# so here we go with the subslot.
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="emacs flambda latex ncurses +ocamlopt spacetime X xemacs"

RDEPEND="
	sys-libs/binutils-libs:=
	ncurses? ( sys-libs/ncurses:0= )
	spacetime? ( sys-libs/libunwind:= )
	X? ( x11-libs/libX11 )
	!dev-ml/num"
BDEPEND="${RDEPEND}
	virtual/pkgconfig"
PDEPEND="emacs? ( app-emacs/ocaml-mode )
	xemacs? ( app-xemacs/ocaml )"

QA_FLAGS_IGNORED='usr/lib.*/ocaml/raw_spacetime_lib.cmxs'

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.04.2-tinfo.patch #459512
	"${WORKDIR}"/${P}-patches-1/
)

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
	EPATCH_SUFFIX="patch" eapply "${WORKDIR}/patches"

	cp "${FILESDIR}"/ocaml.conf "${T}" || die

	default
}

src_configure() {
	export LC_ALL=C
	local myconf=""

	# Causes build failures because it builds some programs with -pg,
	# bug #270920
	filter-flags -fomit-frame-pointer
	# Bug #285993
	filter-mfpmath sse

	# Broken until 4.12
	# bug #818445
	filter-flags '-flto*'
	append-flags -fno-strict-aliasing

	# -ggdb3 & co makes it behave weirdly, breaks sexplib
	replace-flags -ggdb* -ggdb

	# OCaml generates textrels on 32-bit arches
	# We can't do anything about it, but disabling it means that tests
	# for OCaml-based packages won't fail on unexpected output
	# bug #773226
	if use arm || use ppc || use x86 ; then
		append-ldflags "-Wl,-z,notext"
	fi

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
		ewarn "${PN} was built without 'ocamlopt' USE flag; skipping tests."
	fi
}

src_install() {
	emake BINDIR="${ED}"/usr/bin \
		LIBDIR="${ED}"/usr/$(get_libdir)/ocaml \
		MANDIR="${ED}"/usr/share/man \
		install

	# Symlink the headers to the right place
	dodir /usr/include
	# Create symlink for header files
	dosym "../$(get_libdir)/ocaml/caml" /usr/include/caml
	dodoc Changes README.adoc
	# Create envd entry for latex input files
	if use latex ; then
		echo "TEXINPUTS=\"${EPREFIX}/usr/$(get_libdir)/ocaml/ocamldoc:\"" > "${T}"/99ocamldoc || die
		doenvd "${T}"/99ocamldoc
	fi

	sed -i -e "s:lib:$(get_libdir):" "${T}"/ocaml.conf || die

	# Install ocaml-rebuild portage set
	insinto /usr/share/portage/config/sets
	doins "${T}"/ocaml.conf
}
