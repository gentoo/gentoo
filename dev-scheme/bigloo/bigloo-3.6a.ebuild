# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit elisp-common multilib eutils flag-o-matic java-pkg-opt-2

MY_P=${PN}${PV/_p/-}
MY_P=${MY_P/_alpha*/-alpha}
MY_P=${MY_P/_beta*/-beta}

BGL_RELEASE=${PV/_*/}

DESCRIPTION="Bigloo is a Scheme implementation"
HOMEPAGE="http://www-sop.inria.fr/indes/fp/Bigloo/bigloo.html"
SRC_URI="ftp://ftp-sop.inria.fr/indes/fp/Bigloo/${MY_P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="bglpkg calendar crypto debug doc emacs gmp java mail multimedia openpgp packrat sqlite srfi1 srfi27 ssl text threads web"
REQUIRED_USE="
	bglpkg? ( web )
	openpgp? ( crypto )
	packrat? ( srfi1 )
	srfi27? ( x86? ( gmp ) )
"

# bug 254916 for >=dev-libs/boehm-gc-7.1
DEPEND=">=dev-libs/boehm-gc-7.1[threads?]
	emacs? ( virtual/emacs )
	gmp? ( dev-libs/gmp )
	java? ( >=virtual/jdk-1.5 app-arch/zip )
	sqlite? ( dev-db/sqlite:3 )
	ssl? ( dev-libs/openssl )
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P/-[ab]*/}

SITEFILE="50bigloo-gentoo.el"

pkg_pretend() {
	if use srfi27 && use amd64; then
		#TODO: 'dev-scheme/bigloo srfi27' in arch/amd64/package.use.mask?
		ewarn "srfi27 is known to only work on 32-bit architectures." \
			"This IUSE is ignored on amd64."
	fi
}

src_prepare() {
	# Removing bundled boehm-gc
	rm -rf gc || die

	# Fix some printf format warnings
	epatch "${FILESDIR}/${PN}-${BGL_RELEASE}-fix_printf_format_warnings.patch"

	# bug 354751: Fix '[a-z]' sed range for non ascii LC_COLLATE order
	sed 's/a-z/[:alpha:]/' -i configure autoconf/* || die 'sed s/a-z/[:alpha:]/ failed'

	java-pkg-opt-2_src_prepare
}

src_configure() {
	filter-flags -fomit-frame-pointer

	local myconf=""

	# Filter Zile emacs replacement. Bug #336717
	if use emacs; then
		myconf="--bee=full --emacs=${EMACS} --lispdir=${SITELISP}/${PN}"
	else
		myconf="--emacs=false"
	fi

	# Add JCFLAGS to the configure script
	# (api/{crypto,openpgp} jvm tests show failures)
	if use java; then
		sed -e "s/^\(jcflags=\)\(.*\)/\\1\"\\2 $(java-pkg_javac-args)\"/" \
			-e 's/jcflags=$jcflags/jcflags="$jcflags"/'\
			-i configure
		myconf="${myconf}
		--jvm=yes"
	fi

	# No pkglib/pkgcomp in IUSE, I don't see any need besides bglpkg
	# One or the other could be added upon user request
	if use bglpkg; then
		myconf="${myconf}
		--enable-bglpkg --enable-pkgcomp --enable-pkglib"
	else
		myconf="${myconf}
		--disable-bglpkg --disable-pkgcomp --disable-pkglib"
	fi

	# srfi27 management
	if use amd64; then
		myconf="${myconf}
		--disable-srfi27"
	else
		myconf="${myconf}
		$(use_enable srfi27)"
	fi

	# Put every non quoted configure opt into myconf, for the einfo below
	myconf="
		--prefix=/usr
		--libdir=/usr/$(get_libdir)
		--benchmark=yes
		--coflags=
		--customgc=no
		--sharedbde=no
		--sharedcompiler=no
		--strip=no
		$(use debug && echo --debug)
		${myconf}
		$(use_enable calendar)
		$(use_enable crypto)
		$(use_enable gmp)
		--disable-gstreamer
		$(use_enable mail)
		$(use_enable multimedia)
		$(use_enable openpgp)
		$(use_enable packrat)
		--disable-phone
		$(use_enable sqlite)
		$(use_enable srfi1)
		$(use_enable ssl)
		$(use_enable text)
		$(use_enable threads)
		$(use_enable web)
"

	einfo "Configuring bigloo with:" \
		"--ldflags=\"${LDFLAGS}\" $(echo ${myconf} | sed 's/\n\t\t/ /g')"

	# Bigloo doesn't use autoconf and consequently a lot of options used by econf give errors
	# Manuel Serrano says: "Please, dont talk to me about autoconf. I simply dont want to hear about it..."
	./configure --ldflags="${LDFLAGS}" ${myconf} || die "configure failed"
}

src_compile() {
	emake EFLAGS='-ldopt "$(LDFLAGS)"' || die "emake failed"

	if use emacs; then
		einfo "Compiling bee..."
		emake compile-bee EFLAGS='-ldopt "$(LDFLAGS)"' || die "compiling bee failed"
	fi
}

# default thinks that target doesn't exist
src_test() {
	emake -j1 test || die "emake test failed"
}

src_install() {
	# Makefile:671:install: install-progs install-docs
	emake DESTDIR="${D}" install-progs || die "install failed"

	if use emacs; then
		einfo "Installing bee..."
		emake DESTDIR="${D}" install-bee || die "install-bee failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	else
		# Fix EMACS*=false in Makefile.config
		sed -i \
			-e 's:^\(EMACS=\).*$:\1:' \
			-e 's:^\(EMACSBRAND=\).*$:\1:' \
			"${D}"/usr/$(get_libdir)/bigloo/${BGL_RELEASE}/Makefile.config \
			|| die "sed !emacs in Makefile.config failed"
	fi

	dodoc ChangeLog README || die "dodoc failed"

	pushd "${S}/manuals" &>/dev/null
	if use doc; then
		dohtml -r  . || die "dohtml failed"
		doinfo *.info* || die "doinfo failed"
	fi

	for man in *.man; do
		newman ${man} ${man/.man/.1} || die "newman ${man} ${man/.man/.1} failed"
	done
	popd &>/dev/null

	# Remove created directories which remains empty
	pushd "${D}/usr" &>/dev/null
	rmdir -p doc/bigloo-${BGL_RELEASE} info man/man1 || die "rm empty dirs failed"
	popd &>/dev/null
}

pkg_preinst() {
	java-pkg-opt-2_pkg_preinst
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		elog "In order to use the bee-mode, add"
		elog "  (require 'bmacs)"
		elog "to your ~/.emacs file"
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
