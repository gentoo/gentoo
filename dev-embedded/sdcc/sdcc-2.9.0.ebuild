# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils

if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="https://sdcc.svn.sourceforge.net/svnroot/sdcc/trunk/sdcc"
	inherit subversion autotools
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

RDEPEND="sys-libs/ncurses
	sys-libs/readline
	>=dev-embedded/gputils-0.13.7
	boehm-gc? ( dev-libs/boehm-gc )
	!dev-embedded/sdcc-svn"
DEPEND="${RDEPEND}"
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

	epatch "${FILESDIR}"/${P}-gcc44.patch
	epatch "${FILESDIR}"/${P}-getline.patch
	epatch "${FILESDIR}"/${P}-headers.patch
	epatch "${FILESDIR}"/${P}-build.patch

	# We'll install doc manually
	sed -i -e '/SDCC_DOC/d' Makefile.in || die
	sed -i -e 's/all install-doc/all/' as/Makefile.in || die
	sed -i -e 's/ doc//' sim/ucsim/packages_in.mk || die

	[[ ${PV} == "9999" ]] && eautoreconf
}

src_configure() {
	ac_cv_prog_STRIP=true \
	econf \
		$(use_enable boehm-gc libgc) \
		$(docs_compile && use_enable doc || echo --disable-doc)
}

fsrc_compile() {
	emake || die
	if docs_compile && use doc ; then
		cd doc
		local d
		for d in cdbfileformat sdccman test_suite_spec ; do
			lyx -e html ${d} || die
		done
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc doc/*.txt doc/*/*.txt
	find "${D}" -name .deps -exec rm -rf {} +

	if use doc ; then
		docs_compile || cd "${WORKDIR}"/doc
		dohtml -r *
	fi

	# a bunch of archives (*.a) are built & installed by gputils
	# for PIC processors, but they do not work with standard `ar`
	# & `scanelf` utils and they're not for the host.
	env RESTRICT="" prepstrip "${D%/}"/usr/bin
}
