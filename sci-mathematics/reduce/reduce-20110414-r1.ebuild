# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp-common multilib

DESCRIPTION="A general-purpose computer algebra system"
HOMEPAGE="
	http://reduce-algebra.sourceforge.net/
	http://reduce-algebra.com/"
SRC_URI="mirror://sourceforge/${PN}-algebra/${PN}-src-${PV}.tar.bz2"

SLOT="0"
LICENSE="BSD-2 X? ( LGPL-2.1 )"
KEYWORDS="~amd64 ~x86"
IUSE="doc emacs gnuplot X"

RDEPEND="
	X? (
		x11-libs/libXrandr
		x11-libs/libXcursor
		x11-libs/libXft
		)
	gnuplot? ( sci-visualization/gnuplot )
	emacs? ( virtual/emacs )"
DEPEND="${RDEPEND}"

src_configure() {
	# If you pass --prefix to this damn configure,
	# make (not make install!) will try to install stuff
	# into the live file system => sandbox violation
	# Therefore, I cannot use econf here
	# Also, make calls configure in maintainer mode in subdirs *by design*
	# The trunk sucks less => WONTFIX until the next release
	./configure --with-csl $(use_with X gui) || die
	# psl build requires Internet connection at build time
	# we cannot support it
}

src_compile() {
	emake -j1 STRIP=true

	pushd cslbuild/*/csl/reduce.doc > /dev/null
	rm -f *.txt *.tex || die
	popd > /dev/null

	if use emacs; then
		einfo "Compiling emacs lisp files"
		elisp-compile generic/emacs/*.el || die "elisp-compile failed"
	fi
}

src_test() {
	emake -j1 testall
}

src_install() {
	local lib="$(get_libdir)"
	dodoc README BUILDING DEPENDENCY_TRACKING
	pushd bin > /dev/null
	cp "${FILESDIR}"/redcsl "${FILESDIR}"/csl . || die
	sed -e "s/lib/${lib}/" -i redcsl || die
	sed -e "s/lib/${lib}/" -i csl || die
	dobin redcsl csl
	popd > /dev/null

	pushd cslbuild/*/csl > /dev/null
	exeinto /usr/${lib}/${PN}
	doexe reduce csl
	insinto /usr/$(get_libdir)/${PN}
	doins reduce.img csl.img
	insinto /usr/share/${PN}
	doins -r ${PN}.doc
	mv "${D}"usr/share/${PN}/${PN}.doc "${D}"usr/share/${PN}/doc || die
	dosym /usr/share/${PN}/doc /usr/${lib}/${PN}/${PN}.doc
	if use X; then
		doins -r ${PN}.fonts
		mv "${D}"usr/share/${PN}/${PN}.fonts "${D}"usr/share/${PN}/fonts || die
		dosym /usr/share/${PN}/fonts /usr/${lib}/${PN}/${PN}.fonts
	fi
	popd > /dev/null

	if use doc; then
		dodoc doc/util/r38.pdf
	fi

	if use emacs; then
		pushd generic/emacs > /dev/null
		elisp-install ${PN} *.el *.elc || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/64${PN}-gentoo.el"
		popd > /dev/null
	fi
}
