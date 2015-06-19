# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/mlton/mlton-20130715.ebuild,v 1.1 2014/01/15 08:13:28 gienah Exp $

EAPI=5

inherit check-reqs eutils pax-utils

DESCRIPTION="Standard ML optimizing compiler and libraries"
BASE_URI="mirror://sourceforge/${PN}"
SRC_URI="!binary? ( ${BASE_URI}/${P}.src.tgz )
		  binary? ( amd64? ( ${BASE_URI}/${P}-1.amd64-linux.tgz )
					x86?   ( ${BASE_URI}/${P}-1.x86-linux.tgz ) )"

HOMEPAGE="http://www.mlton.org"

LICENSE="HPND MIT"
SLOT="0/${PV}"
# there is support for ppc64 and ia64, but no
# binaries are provided and there is no native
# code generation for these platforms
KEYWORDS="-* ~amd64 ~x86"
IUSE="binary doc"

DEPEND="dev-libs/gmp
		doc? ( virtual/latex-base )"
RDEPEND="dev-libs/gmp"

QA_PRESTRIPPED="binary? (
	usr/bin/mlnlffigen
	usr/bin/mllex
	usr/bin/mlprof
	usr/bin/mlyacc
	usr/lib/mlton/mlton-compile
)"

# The resident set size of mlton-compile is 10GB on amd64
CHECKREQS_MEMORY="4G"

pkg_pretend() {
	if use !binary; then
		check-reqs_pkg_pretend
	fi
}

src_unpack() {
	if use !binary; then
		unpack ${A}
	else
		mkdir -p "${S}" || die "Could not create ${S} directory"
		pushd "${S}" || die "Could not cd to ${S}"
		unpack ${A}
		popd
	fi
}

src_prepare() {
	if use !binary; then
		# The patch removing executable permissions from mmap'd memory regions is not upstreamed:
		# http://pkgs.fedoraproject.org/cgit/mlton.git/tree/mlton-20070826-no-execmem.patch
		epatch "${FILESDIR}/${PN}-20070826-no-execmem.patch"
		# PIE in hardened requires executables to be linked with -fPIC. mlton by default tries
		# to link executables against the non PIC objects in libmlton.a.  We may be bootstrapping
		# with an old mlton install, if we tried to patch it (to link with libmlton-pic.a) we would
		# need a patched binary.
		# http://mlton.org/MLtonWorld says Executables that save and load worlds are incompatible
		# with address space layout randomization (ASLR) of the executable.
		epatch "${FILESDIR}/${PN}-20130715-no-PIE.patch"
		# Remove dirs runtime compiler from all-no-docs to avoid repeating these steps.
		# As we need to pax-mark the mlton-compiler executable.
		epatch "${FILESDIR}/${PN}-20130715-split-make-for-pax-mark.patch"
	fi
}

src_compile() {
	if use !binary; then
		has_version dev-lang/mlton || die "emerge with binary use flag first"

		# Fix location in which to install man pages
		sed -i 's@^MAN_PREFIX_EXTRA :=.*@MAN_PREFIX_EXTRA := /share@' \
			Makefile || die 'sed Makefile failed'

		emake -j1 dirs runtime compiler CFLAGS="${CFLAGS}" || die
		pax-mark m "${S}/mlton/mlton-compile"
		pax-mark m "${S}/build/lib/mlton-compile"

		# Does not support parallel make
		emake -j1 all-no-docs CFLAGS="${CFLAGS}" || die
		if use doc; then
			export VARTEXFONTS="${T}/fonts"
			emake docs || die "failed to create documentation"
		fi
	fi
}

src_install() {
	if use binary; then
		# Fix location in which to install man pages
		mv "${S}/usr/man" "${S}/usr/share" || die "mv man failed"
		pax-mark m "${S}/usr/lib/mlton/mlton-compile"
		pax-mark m "${S}/usr/bin/mllex"
		pax-mark m "${S}/usr/bin/mlyacc"
		mv "${S}/usr" "${D}" || die "mv failed"
	else
		emake DESTDIR="${D}" install-no-docs || die
		if use doc; then emake DESTDIR="${D}" TDOC="${D}"/usr/share/doc/${P} install-docs || die; fi
	fi
}

pkg_postinst() {
	# There are PIC objects in libmlton-pic.a. -link-opt -lmlton-pic does not help as mlton
	# specifies -lmlton before -lmlton-pic. It appears that it would be necessary to patch mlton
	# to convince mlton to use the lib*-pic.a libraries when linking an executable.
	ewarn 'PIE in Gentoo hardened requires executables to be linked with -fPIC. mlton by default links'
	ewarn 'executables against the non PIC objects in libmlton.a.  http://mlton.org/MLtonWorld notes:'
	ewarn 'Executables that save and load worlds are incompatible with address space layout'
	ewarn 'randomization (ASLR) of the executable.'
	ewarn 'To suppress the generation of position-independent executables.'
	ewarn '-link-opt -fno-PIE'
}
