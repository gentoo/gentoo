# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib

# test phase only works if ecls already installed #516876
RESTRICT="test"

MY_P=ecl-${PV}

DESCRIPTION="ECL is an embeddable Common Lisp implementation"
HOMEPAGE="https://common-lisp.net/project/ecl/"
SRC_URI="https://common-lisp.net/project/ecl/files/release/${PV}/${MY_P}.tgz"

LICENSE="BSD LGPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="cxx debug emacs gengc precisegc cpu_flags_x86_sse +threads +unicode +libatomic X"

CDEPEND="dev-libs/gmp:0
		virtual/libffi
		libatomic? ( dev-libs/libatomic_ops )
		>=dev-libs/boehm-gc-7.1[threads?]
		>=dev-lisp/asdf-2.33-r3:="
DEPEND="${CDEPEND}
		app-text/texi2html
		emacs? ( virtual/emacs >=app-eselect/eselect-emacs-1.12 )"
RDEPEND="${CDEPEND}"

S="${WORKDIR}"/${MY_P}

pkg_setup () {
	if use gengc || use precisegc ; then
		ewarn "You have enabled the generational garbage collector or"
		ewarn "the precise collection routines. These features are not very stable"
		ewarn "at the moment and may cause crashes."
		ewarn "Don't enable them unless you know what you're doing."
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-headers-gentoo.patch
	cp "${EPREFIX}"/usr/share/common-lisp/source/asdf/build/asdf.lisp contrib/asdf/ || die
}

src_configure() {
	econf \
		--with-system-gmp \
		--enable-boehm=system \
		--enable-longdouble=yes \
		--with-dffi \
		$(use_with cxx) \
		$(use_enable gengc) \
		$(use_enable precisegc) \
		$(use_with debug debug-cflags) \
		$(use_enable libatomic libatomic system) \
		$(use_with cpu_flags_x86_sse sse) \
		$(use_enable threads) \
		$(use_with threads __thread) \
		$(use_enable unicode) \
		$(use_with unicode unicode-names) \
		$(use_with X x) \
		$(use_with X clx)
}

src_compile() {
	if use emacs; then
		local ETAGS=$(eselect --brief etags list | sed -ne '/emacs/{p;q}')
		[[ -n ${ETAGS} ]] || die "No etags implementation found"
		pushd build > /dev/null || die
		emake ETAGS=${ETAGS} TAGS
		popd > /dev/null
	else
		touch build/TAGS
	fi

	#parallel make fails
	emake -j1 || die "Compilation failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "Installation failed"

	dodoc README.md CHANGELOG
	dodoc "${FILESDIR}"/README.Gentoo
	pushd build/doc
	newman ecl.man ecl.1
	newman ecl-config.man ecl-config.1
	popd
}
