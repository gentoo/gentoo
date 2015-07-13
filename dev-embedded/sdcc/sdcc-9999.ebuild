# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/sdcc/sdcc-9999.ebuild,v 1.9 2015/07/13 09:21:51 vapier Exp $

EAPI="5"

inherit eutils toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="https://sdcc.svn.sourceforge.net/svnroot/sdcc/trunk/sdcc"
	inherit subversion
	docs_compile() { return 0; }
else
	SRC_URI="mirror://sourceforge/sdcc/${PN}-src-${PV}.tar.bz2
		doc? ( mirror://sourceforge/sdcc/${PN}-doc-${PV}.tar.bz2 )"
	KEYWORDS="~amd64 ~ppc ~x86"
	docs_compile() { return 1; }
fi

DESCRIPTION="Small device C compiler (for various microprocessors)"
HOMEPAGE="http://sdcc.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+boehm-gc doc"
RESTRICT="strip"

RDEPEND="dev-libs/boost:=
	sys-libs/ncurses:=
	sys-libs/readline:0=
	>=dev-embedded/gputils-0.13.7
	boehm-gc? ( dev-libs/boehm-gc:= )
	!dev-embedded/sdcc-svn"
DEPEND="${RDEPEND}
	dev-util/gperf"
if docs_compile ; then
	DEPEND+="
		doc? (
			>=app-office/lyx-1.3.4
			dev-tex/latex2html
		)"
fi

S=${WORKDIR}/${PN}

src_prepare() {
	# Fix conflicting variable names between Gentoo and sdcc
	find \
		'(' -name 'Makefile*.in' -o -name configure ')' \
		-exec sed -r -i \
			-e 's:\<(PORTDIR|ARCH)\>:SDCC\1:g' \
			{} + || die

	# https://sourceforge.net/p/sdcc/bugs/2398/
	sed -i '1iAR = @AR@' Makefile.common.in || die
	sed -i \
		-e "/^AR =/s:=.*:=$(tc-getAR):" \
		support/cpp/Makefile.in || die

	# We'll install doc manually
	sed -i -e '/SDCC_DOC/d' Makefile.in || die
	sed -i -e 's/ doc//' sim/ucsim/packages_in.mk || die

	# Make sure timestamps don't get messed up.
	[[ ${PV} == "9999" ]] && find "${S}" -type f -exec touch -r . {} +

	# workaround parallel build issues with lyx
	mkdir -p "${HOME}"/.lyx
}

src_configure() {
	# sdbinutils subdir doesn't pass down --docdir properly, so need to
	# expand $(datarootdir) ourselves.
	econf \
		ac_cv_prog_STRIP=true \
		ac_cv_prog_AS="$(tc-getAS)" \
		ac_cv_prog_AR="$(tc-getAR)" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--without-ccache \
		$(use_enable boehm-gc libgc) \
		$(docs_compile && use_enable doc || echo --disable-doc)
}

src_install() {
	default
	dodoc doc/*.txt
	find "${D}" -name .deps -exec rm -rf {} + || die

	if use doc ; then
		docs_compile || cd "${WORKDIR}"/doc
		dohtml -r *
	fi

	# a bunch of archives (*.a) are built & installed by gputils
	# for PIC processors, but they do not work with standard `ar`
	# & `scanelf` utils and they're not for the host.
	env RESTRICT="" prepstrip "${D%/}"/usr/bin
}
