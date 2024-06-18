# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PV=${PV:0:3}

DESCRIPTION="CMU Common Lisp is an implementation of ANSI Common Lisp"
HOMEPAGE="https://www.cons.org/cmucl/"
SRC_URI="
	https://common-lisp.net/project/cmucl/downloads/release/${MY_PV}/cmucl-src-${MY_PV}.tar.bz2
	https://common-lisp.net/project/cmucl/downloads/release/${MY_PV}/cmucl-${MY_PV}-x86-linux.tar.bz2
"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="-* x86"
IUSE="doc gui source"

CDEPEND=">=dev-lisp/asdf-2.33-r3:=
	x11-libs/motif:0"
DEPEND="${CDEPEND}
	app-alternatives/bc
	doc? ( virtual/latex-base )"
RDEPEND="${CDEPEND}"

TARGET=linux-4

src_prepare() {
	eapply "${FILESDIR}"/${PN}-21c-execstack-fixes.patch
	eapply "${FILESDIR}"/${P}-version.patch
	eapply_user
	#cp "${FILESDIR}"/os-common.h src/lisp/ || die
	cp /usr/share/common-lisp/source/asdf/build/asdf.lisp src/contrib/asdf/ || die
}

src_compile() {
	local cmuopts=$(usex gui "" -u)
	local buildimage="bin/lisp -batch"

	env CC="$(tc-getCC)" bin/build.sh -v "-gentoo-${PR}" -C "" \
		-o "${buildimage}" ${cmuopts} \
		|| die "Cannot build the compiler"

	# Compile up the asdf and defsystem modules
	${TARGET}/lisp/lisp -noinit -nositeinit -batch << EOF || die
(in-package :cl-user)
(setf (ext:search-list "target:")
	  '("$TARGET/" "src/"))
(setf (ext:search-list "modules:")
	  '("target:contrib/"))

(compile-file "modules:asdf/asdf")
(compile-file "modules:defsystem/defsystem")
EOF

	# Documentation
	if use doc; then
		pushd src/docs/cmu-user > /dev/null \
			|| die "directory src/docs/cmu-user does not exist"
		emake
		cd ../internals || die "directory src/docs/internals does not exist"
		emake
		popd > /dev/null || die
	fi
}

src_install() {
	DOCDIR=share/doc/${PF} bin/make-dist.sh -S -g -G root -O root \
		-M share/man/man1 -V ${MY_PV} -A x86 -o linux ${TARGET} \
		|| die "Cannot build installation archive"
	# Necessary otherwise tar will fail
	dodir /usr
	pushd "${D}"/usr > /dev/null || die
	tar xzpf "${WORKDIR}"/cmucl-${MY_PV}-x86-linux.tar.gz \
		|| die "Cannot install main system"
	if use gui ; then
		tar xzpf "${WORKDIR}"/cmucl-${MY_PV}-x86-linux.extra.tar.gz \
			|| die "Cannot install extra files"
	fi
	if use source; then
		# Necessary otherwise tar will fail
		dodir /usr/share/common-lisp/source/${PN}
		cd "${D}"/usr/share/common-lisp/source/${PN} || die
		tar --strip-components 1 -xzpf "${WORKDIR}"/cmucl-src-${MY_PV}.tar.gz \
			|| die "Cannot install sources"
	fi
	popd > /dev/null || die

	# Install site config file
	sed "s,@PF@,${PF},g ; s,@VERSION@,$(date +%F),g" \
		< "${FILESDIR}"/site-init.lisp.in \
		> "${D}"/usr/$(get_libdir)/cmucl/site-init.lisp \
		|| die "Cannot fix site-init.lisp"
	insinto /etc/common-lisp
	doins "${FILESDIR}"/cmuclrc

	# Documentation
	if use doc; then
		dodoc src/docs/cmu-user/cmu-user.pdf src/docs/internals/design.pdf
		docompress -x /usr/share/doc/${PF}/{cmu-user,design}.pdf
	fi
}
