# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit elisp-common eutils

PATCHSET_VER="5"
MY_P="mozart-${PV}.20080704"

DESCRIPTION="Advanced development platform for intelligent, distributed applications"
HOMEPAGE="http://www.mozart-oz.org/"
SRC_URI="
	http://www.mozart-oz.org/download/mozart-ftp/store/1.4.0-2008-07-02-tar/mozart-1.4.0.20080704-src.tar.gz
	mirror://gentoo/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz
	doc? ( http://www.mozart-oz.org/download/mozart-ftp/store/1.4.0-2008-07-02-tar/mozart-1.4.0.20080704-doc.tar.gz )"

SLOT="0"
LICENSE="Mozart"
KEYWORDS="-amd64 ppc -ppc64 x86"
IUSE="doc emacs examples gdbm static tcl threads tk"

RDEPEND="
	dev-lang/perl
	dev-libs/gmp
	sys-libs/zlib
	emacs? ( virtual/emacs )
	gdbm? ( sys-libs/gdbm  )
	tcl? (
		tk? (
			dev-lang/tk:0
			dev-lang/tcl:0
		)
	)"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

SITEFILE=50${PN}-gentoo.el

S="${WORKDIR}"/${MY_P}

src_prepare() {
	EPATCH_FORCE=yes
	EPATCH_SUFFIX=patch
	epatch "${WORKDIR}"/${PV}
}

src_configure() {
	local myconf="\
			--without-global-oz \
			--enable-opt=none"

	if use tcl && use tk ; then
		myconf="${myconf} --enable-wish"
	else
		myconf="${myconf} --disable-wish"
	fi

	econf \
		${myconf} \
		--disable-doc \
		--enable-contrib \
		--disable-contrib-micq \
		$(use_enable doc contrib-doc) \
		$(use_enable gdbm contrib-gdbm) \
		$(use_enable tk contrib-tk) \
		$(use_enable emacs compile-elisp) \
		$(use_enable static link-static) \
		$(use_enable threads threaded)
}

src_compile() {
	emake bootstrap || die "emake bootstrap failed"
}

src_test() {
	# Mozart tests must be run single-threaded
	cd "${S}"/share/test
	emake -j1 boot-oztest || die "emake boot-oztest failed"
	emake -j1 boot-check || die "emake boot-check failed"
}

src_install() {
	emake \
		PREFIX="${D}"/usr/lib/mozart \
		ELISPDIR="${D}${SITELISP}/${PN}" \
		install || die "emake install failed"

	dosym /usr/lib/mozart/bin/convertTextPickle /usr/bin/convertTextPickle || die
	dosym /usr/lib/mozart/bin/oldpickle2text /usr/bin/oldpickle2text || die
	dosym /usr/lib/mozart/bin/ozc /usr/bin/ozc || die
	dosym /usr/lib/mozart/bin/ozd /usr/bin/ozd || die
	dosym /usr/lib/mozart/bin/ozengine /usr/bin/ozengine || die
	dosym /usr/lib/mozart/bin/ozl /usr/bin/ozl || die
	dosym /usr/lib/mozart/bin/ozplatform /usr/bin/ozplatform || die
	dosym /usr/lib/mozart/bin/oztool /usr/bin/oztool || die
	dosym /usr/lib/mozart/bin/pickle2text /usr/bin/pickle2text || die
	dosym /usr/lib/mozart/bin/text2pickle /usr/bin/text2pickle || die

	if use emacs; then
		dosym /usr/lib/mozart/bin/oz /usr/bin/oz || die
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" \
			|| die "elisp-site-file-install failed"
	fi

	if use doc ; then
		dohtml -r "${WORKDIR}"/mozart/doc/* || die
	fi

	if use examples; then
		cd "${S}"/share
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/* || die
		doins -r demo/* || die
		rm -rf $(find "${D}"/usr/share/doc/${PF}/examples \
			-name Makefile -o -name Makefile.in)
	fi

	cd "${S}"
	dodoc README || die
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
