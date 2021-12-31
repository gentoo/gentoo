# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic libtool texlive-common

DESCRIPTION="An extended version of pdfTeX using Lua as an embedded scripting language"
HOMEPAGE="http://www.luatex.org/"
SRC_URI="http://foundry.supelec.fr/gf/download/frsrelease/392/1730/${PN}-beta-${PV}.tar.bz2
	http://foundry.supelec.fr/gf/download/frsrelease/392/1732/${PN}-beta-${PV}-doc.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

RDEPEND="dev-libs/zziplib
	>=media-libs/libpng-1.4
	app-text/poppler:=[xpdf-headers(+)]
	sys-libs/zlib:*
	>=dev-libs/kpathsea-6.0.1_p20110627"

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-beta-${PV}/source"
PRELIBS="libs/obsdcompat"
#texk/kpathsea"
#kpathsea_extraconf="--disable-shared --disable-largefile"

src_prepare() {
	default
	has_version '>=app-text/poppler-0.18.0:0' && eapply "${FILESDIR}/poppler018.patch"
	has_version '>=app-text/poppler-0.20.0:0' && eapply "${FILESDIR}/poppler020.patch"
	has_version '>=app-text/poppler-0.22.0:0' && eapply "${FILESDIR}/poppler022.patch"
	has_version '>=app-text/poppler-0.26.0:0' && eapply "${FILESDIR}/poppler026-backport.patch"
	has_version '>=app-text/poppler-0.57.0:0' && append-cxxflags -std=c++11 # bug 627538
	eapply "${FILESDIR}/kpathsea2012.patch" \
		"${FILESDIR}/remove-zlib-version-check.patch"
	S="${S}/build-aux" elibtoolize --shallow
}

src_configure() {
	# Too many regexps use A-Z a-z constructs, what causes problems with locales
	# that don't have the same alphabetical order than ascii. Bug #244619
	# So we set LC_ALL to C in order to avoid problems.
	export LC_ALL=C

	local myconf
	myconf=""
	#has_version '>=app-text/texlive-core-2009' && myconf="--with-system-kpathsea"

	cd "${S}/texk/web2c" || die
	econf \
		--disable-cxx-runtime-hack \
		--disable-all-pkgs	\
		--disable-mp		\
		--disable-ptex		\
		--disable-tex		\
		--disable-mf		\
	    --disable-largefile \
		--disable-ipc		\
		--disable-shared	\
		--enable-luatex		\
		--enable-dump-share	\
		--without-mf-x-toolkit \
		--without-x			\
	    --with-system-kpathsea	\
	    --with-kpathsea-includes="${EPREFIX}"/usr/include \
	    --with-system-gd	\
	    --with-system-libpng	\
	    --with-system-teckit \
	    --with-system-zlib \
	    --with-system-t1lib \
		--with-system-xpdf \
		--with-system-poppler \
		--with-system-zziplib \
	    --disable-multiplatform

	for i in ${PRELIBS} ; do
		einfo "Configuring $i"
		local j=$(basename $i)_extraconf
		local myconf
		eval myconf=\${$j}
		cd "${S}/${i}" || die
		econf ${myconf}
	done
}

src_compile() {
	texk/web2c/luatexdir/getluatexsvnversion.sh || die
	for i in ${PRELIBS} ; do
		cd "${S}/${i}" || die
		emake
	done
	cd "${WORKDIR}/${PN}-beta-${PV}/source/texk/web2c" || die
	emake luatex
}

src_install() {
	cd "${WORKDIR}/${PN}-beta-${PV}/source/texk/web2c" || die
	emake DESTDIR="${D}" bin_PROGRAMS="luatex" SUBDIRS="" nodist_man_MANS="" \
		install-exec-am

	dodoc "${WORKDIR}/${PN}-beta-${PV}/README"
	doman "${WORKDIR}/texmf/doc/man/man1/"*.1
	if use doc ; then
		dodoc "${WORKDIR}/${PN}-beta-${PV}/manual/"*.pdf
		dodoc "${WORKDIR}/texmf/doc/man/man1/"*.pdf
	fi
}

pkg_postinst() {
	if ! has_version '>=dev-texlive/texlive-basic-2008' ; then
		elog "Note that this package does not install many files, mainly just the"
		elog "${PN} executable, which needs other files in order to be"
		elog "useful. Please consider installing a recent TeX distribution such as"
		elog "TeX Live 2008 or later to take advantage of the full power of"
		elog "${PN} ."
	fi
	efmtutil-sys
}
