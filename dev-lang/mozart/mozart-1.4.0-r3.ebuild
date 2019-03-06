# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp-common eutils

PATCHSET_VER="5"
MY_P="mozart-${PV}.20080704"

DESCRIPTION="Advanced development platform for intelligent, distributed applications"
HOMEPAGE="https://mozart.github.io/ https://github.com/mozart/mozart"
SRC_URI="
	mirror://sourceforge/project/mozart-oz/v1/1.4.0-2008-07-02-tar/${MY_P}-src.tar.gz
	mirror://gentoo/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz
	doc? ( mirror://sourceforge/project/mozart-oz/v1/1.4.0-2008-07-02-tar/${MY_P}-doc.tar.gz )"

SLOT="0"
LICENSE="Mozart"
KEYWORDS="-amd64 ppc -ppc64 x86"
IUSE="doc emacs examples gdbm static tcl threads tk"

RDEPEND="
	dev-lang/perl
	dev-libs/gmp:0=
	sys-libs/zlib
	emacs? ( virtual/emacs )
	gdbm? ( sys-libs/gdbm  )
	tcl? (
		tk? (
			dev-lang/tk:0=
			dev-lang/tcl:0=
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
	emake bootstrap
}

src_test() {
	# Mozart tests must be run single-threaded
	cd "${S}"/share/test || die
	emake -j1 boot-oztest
	emake -j1 boot-check
}

src_install() {
	emake \
		PREFIX="${D}"/usr/lib/mozart \
		ELISPDIR="${D}${SITELISP}/${PN}" \
		install

	dosym /usr/lib/mozart/bin/convertTextPickle /usr/bin/convertTextPickle
	dosym /usr/lib/mozart/bin/oldpickle2text /usr/bin/oldpickle2text
	dosym /usr/lib/mozart/bin/ozc /usr/bin/ozc
	dosym /usr/lib/mozart/bin/ozd /usr/bin/ozd
	dosym /usr/lib/mozart/bin/ozengine /usr/bin/ozengine
	dosym /usr/lib/mozart/bin/ozl /usr/bin/ozl
	dosym /usr/lib/mozart/bin/ozplatform /usr/bin/ozplatform
	dosym /usr/lib/mozart/bin/oztool /usr/bin/oztool
	dosym /usr/lib/mozart/bin/pickle2text /usr/bin/pickle2text
	dosym /usr/lib/mozart/bin/text2pickle /usr/bin/text2pickle

	if use emacs; then
		dosym /usr/lib/mozart/bin/oz /usr/bin/oz
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	dodoc "${S}"/README
	use doc && dohtml -r "${WORKDIR}"/mozart/doc/*

	if use examples; then
		cd "${S}"/share || die
		insinto /usr/share/doc/${PF}
		doins -r examples demo
		rm -rf $(find "${ED}"/usr/share/doc/${PF}/examples \
			-name Makefile -o -name Makefile.in) || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
