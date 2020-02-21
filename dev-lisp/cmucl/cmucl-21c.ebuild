# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs multilib

MY_PV=${PV:0:3}

DESCRIPTION="CMU Common Lisp is an implementation of ANSI Common Lisp"
HOMEPAGE="http://www.cons.org/cmucl/"
SRC_URI="http://common-lisp.net/project/cmucl/downloads/release/${MY_PV}/cmucl-src-${MY_PV}.tar.bz2
	http://common-lisp.net/project/cmucl/downloads/release/${MY_PV}/cmucl-${MY_PV}-x86-linux.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="x86"
IUSE="X doc source"

CDEPEND=">=dev-lisp/asdf-2.33-r3:=
		 x11-libs/motif:0"
DEPEND="${CDEPEND}
	sys-devel/bc
	doc? ( virtual/latex-base )"
RDEPEND="${CDEPEND}"

S="${WORKDIR}"

TARGET=linux-4

src_prepare() {
	eapply "${FILESDIR}"/${P}-execstack-fixes.patch
	eapply "${FILESDIR}"/${P}-build.patch
	eapply_user
	#cp "${FILESDIR}"/os-common.h src/lisp/ || die
	cp /usr/share/common-lisp/source/asdf/build/asdf.lisp src/contrib/asdf/ || die
}

src_compile() {
	local cmuopts buildimage

	if use X ; then
		cmuopts=""
	else
		cmuopts="-u"
	fi

	buildimage="bin/lisp -batch"

	env CC="$(tc-getCC)" bin/build.sh -v "-gentoo-${PR}" -C "" -o "${buildimage}" ${cmuopts} || die "Cannot build the compiler"

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
		pushd src/docs/cmu-user > /dev/null || die "directory src/docs/cmu-user does not exist"
		emake
		cd ../internals || die "directory src/docs/internals does not exist"
		emake
		popd > /dev/null
	fi
}

src_install() {
	bin/make-dist.sh -S -g -G root -O root -M share/man/man1 -V ${MY_PV} -A x86 -o linux ${TARGET} \
		|| die "Cannot build installation archive"
	# Necessary otherwise tar will fail
	dodir /usr
	pushd "${D}"/usr > /dev/null
	tar xzpf "${WORKDIR}"/cmucl-${MY_PV}-x86-linux.tar.gz \
		|| die "Cannot install main system"
	if use X ; then
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
	popd > /dev/null

	# Install site config file
	sed "s,@PF@,${PF},g ; s,@VERSION@,$(date +%F),g" \
		< "${FILESDIR}"/site-init.lisp.in \
		> "${D}"/usr/$(get_libdir)/cmucl/site-init.lisp \
		|| die "Cannot fix site-init.lisp"
	insinto /etc/common-lisp
	doins "${FILESDIR}"/cmuclrc

	# Documentation
	dodoc doc/cmucl/README
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins src/docs/cmu-user/cmu-user.pdf src/docs/internals/design.pdf
	fi
}
