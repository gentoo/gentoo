# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Programming language supporting functional, imperative & object-oriented styles"
HOMEPAGE="https://ocaml.org/"
SRC_URI="https://github.com/ocaml/ocaml/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-patches-1.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="emacs flambda latex +ocamlopt spacetime xemacs"

RDEPEND="sys-libs/binutils-libs:=
	spacetime? ( sys-libs/libunwind:= )"
BDEPEND="${RDEPEND}
	virtual/pkgconfig"
PDEPEND="emacs? ( app-emacs/ocaml-mode )
	xemacs? ( app-xemacs/ocaml )"

QA_FLAGS_IGNORED='usr/lib.*/ocaml/bigarray.cmxs'

PATCHES=(
	"${WORKDIR}"/${P}-patches-1/
)

src_prepare() {
	default

	cp "${FILESDIR}"/ocaml.conf "${T}" || die

	# Broken until 4.12
	# bug #818445
	filter-flags '-flto*'
	append-flags -fno-strict-aliasing

	# OCaml generates textrels on 32-bit arches
	# We can't do anything about it, but disabling it means that tests
	# for OCaml-based packages won't fail on unexpected output
	# bug #773226
	if use arm || use ppc || use x86 ; then
		append-ldflags "-Wl,-z,notext"
	fi

	# Upstream build ignores LDFLAGS in several places.
	sed -i -e 's/\(^MKDLL=.*\)/\1 $(LDFLAGS)/' \
		-e 's/\(^OC_CFLAGS=.*\)/\1 $(LDFLAGS)/' \
		-e 's/\(^OC_LDFLAGS=.*\)/\1 $(LDFLAGS)/' \
		Makefile.config.in || die "LDFLAGS fix failed"
	# ${P} overrides upstream build's own P due to a wrong assignment operator.
	sed -i -e 's/^P ?=/P =/' stdlib/StdlibModules || die "P fix failed"
}

src_configure() {
	local opt=(
		--bindir="${EPREFIX}/usr/bin"
		--libdir="${EPREFIX}/usr/$(get_libdir)/ocaml"
		--mandir="${EPREFIX}/usr/share/man"
		--prefix="${EPREFIX}/usr"
		$(use_enable flambda)
		$(use_enable spacetime)
	)

	econf "${opt[@]}"
}

src_compile() {
	if use ocamlopt ; then
		emake world.opt
	else
		emake world
	fi
}

src_test() {
	if use ocamlopt ; then
		# OCaml tests only work when run sequentially
		emake -j1 -C testsuite all
	else
		ewarn "${PN} was built without 'ocamlopt' USE flag; skipping tests."
	fi
}

src_install() {
	default
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
