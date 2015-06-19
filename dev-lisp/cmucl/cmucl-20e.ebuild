# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cmucl/cmucl-20e.ebuild,v 1.3 2015/05/23 15:16:34 pacho Exp $

EAPI=5
inherit eutils toolchain-funcs multilib

MY_PV=${PV:0:3}

DESCRIPTION="CMU Common Lisp is an implementation of ANSI Common Lisp"
HOMEPAGE="http://www.cons.org/cmucl/"
SRC_URI="http://common-lisp.net/project/cmucl/downloads/release/${MY_PV}/cmucl-src-${MY_PV}.tar.bz2
	http://common-lisp.net/project/cmucl/downloads/release/${MY_PV}/cmucl-${MY_PV}-x86-linux.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="x86"
IUSE="X source cpu_flags_x86_sse2"

CDEPEND=">=dev-lisp/asdf-2.33-r3:=
		 x11-libs/motif:0"
DEPEND="${CDEPEND}
		sys-devel/bc"
RDEPEND="${CDEPEND}"

S="${WORKDIR}"

TARGET=linux-4

src_prepare() {
	epatch "${FILESDIR}"/${MY_PV}-execstack-fixes.patch
	epatch "${FILESDIR}"/${MY_PV}-customize-lisp-implementation-version.patch

	cp /usr/share/common-lisp/source/asdf/build/asdf.lisp src/contrib/asdf/ || die
}

src_compile() {
	local cmufpu cmuopts

	if use cpu_flags_x86_sse2; then
		cmufpu=sse2
	else
		cmufpu=x87
	fi

	if use X; then
		cmuopts="-f ${cmufpu}"
	else
		cmuopts="-u -f ${cmufpu}"
	fi

	local buildimage="bin/lisp -core lib/cmucl/lib/lisp-${cmufpu}.core -noinit -nositeinit -batch"

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
}

src_install() {
	env MANDIR=share/man/man1 DOCDIR=share/doc/${PF} \
		bin/make-dist.sh -S -g -G root -O root ${TARGET} ${MY_PV} x86 linux \
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
		cd "${D}"/usr/share/common-lisp/source/${PN}
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
	doins "${FILESDIR}"/cmuclrc || die "Failed to install cmuclrc"
}
