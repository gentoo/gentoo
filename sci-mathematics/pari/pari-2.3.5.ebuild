# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/pari/pari-2.3.5.ebuild,v 1.15 2014/03/06 17:26:35 jer Exp $

EAPI=3
inherit elisp-common eutils flag-o-matic toolchain-funcs

DESCRIPTION="A software package for computer-aided number theory"
HOMEPAGE="http://pari.math.u-bordeaux.fr/"

SRC_COM="http://pari.math.u-bordeaux.fr/pub/${PN}"
SRC_URI="${SRC_COM}/unix/${P}.tar.gz
	data? (	${SRC_COM}/packages/elldata.tgz
			${SRC_COM}/packages/galdata.tgz
			${SRC_COM}/packages/seadata.tgz
			${SRC_COM}/packages/nftables.tgz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-solaris"
IUSE="doc data fltk gmp static-libs X"

RDEPEND="sys-libs/readline
	fltk? ( x11-libs/fltk:1 )
	gmp? ( dev-libs/gmp )
	X? ( x11-libs/libX11 )
	doc? ( X? ( x11-misc/xdg-utils ) )"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

get_compile_dir() {
	pushd "${S}/config" >& /dev/null
	local fastread=yes
	source ./get_archos
	popd >& /dev/null
	echo "O${osname}-${arch}"
}

src_prepare() {
	# move data into place
	if use data; then
		mv "${WORKDIR}"/data "${S}" || die "failed to move data"
	fi
	epatch "${FILESDIR}/"${PN}-2.3.2-strip.patch
	epatch "${FILESDIR}/"${PN}-2.3.2-ppc-powerpc-arch-fix.patch
	epatch "${FILESDIR}/"${PN}-2.3.5-doc-make.patch

	# disable default building of docs during install
	sed -i \
		-e "s:install-doc install-examples:install-examples:" \
		config/Makefile.SH || die "Failed to fix makefile"
	# propagate ldflags
	sed -i \
		-e 's/-shared $extra/-shared $extra \\$(LDFLAGS)/' \
		config/get_dlld || die "Failed to fix LDFLAGS"
	# move doc dir to a gentoo doc dir and replace hardcoded xdvi by xdg-open
	sed -i \
		-e "s:\$d = \$0:\$d = '${EPREFIX}/usr/share/doc/${PF}':" \
		-e 's:"xdvi":"xdg-open":' \
		-e 's:xdvi -paper 29.7x21cm:xdg-open:' \
		doc/gphelp.in || die "Failed to fix doc dir"
	# disable emacs support
	sed -i -e '/^list=/s/emacs//' Configure \
		|| die
}

src_configure() {
	append-flags -fno-strict-aliasing
	tc-export CC
	# need to force optimization here, as it breaks without
	if   is-flag -O0; then
		replace-flags -O0 -O2
	elif ! is-flag -O?; then
		append-flags -O2
	fi
	# sysdatadir installs a pari.cfg stuff which is informative only
	./Configure \
		--prefix="${EPREFIX}"/usr \
		--datadir="${EPREFIX}"/usr/share/${PN} \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--sysdatadir="${EPREFIX}"/usr/share/doc/${PF} \
		--mandir="${EPREFIX}"/usr/share/man/man1 \
		--with-readline \
		$(use_with gmp) \
		|| die "./Configure failed"
}

src_compile() {
	local installdir=$(get_compile_dir)
	cd "${installdir}" || die "Bad directory"

	emake ${mymake} CFLAGS="${CFLAGS} -DGCC_INLINE -fPIC" lib-dyn \
		|| die "Building shared library failed!"

	if use static-libs; then
		emake ${mymake} CFLAGS="${CFLAGS} -DGCC_INLINE" lib-sta \
			|| die "Building static library failed!"
	fi

	emake ${mymake} CFLAGS="${CFLAGS} -DGCC_INLINE" gp ../gp \
		|| die "Building executables failed!"

	if use doc; then
		cd "${S}"
		# To prevent sandbox violations by metafont
		VARTEXFONTS="${T}"/fonts emake docpdf \
			|| die "Failed to generate docs"
	fi
}

src_test() {
	emake test-kernel || die
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	dodoc AUTHORS Announce.2.1 CHANGES README NEW MACHINES COMPAT
	if use doc; then
		emake \
			DESTDIR="${D}" \
			EXDIR="${ED}/usr/share/doc/${PF}/examples" \
			DOCDIR="${ED}/usr/share/doc/${PF}" \
			install-doc || die "Failed to install docs"
		insinto /usr/share/doc/${PF}
		doins doc/*.pdf || die "Failed to install pdf docs"
	fi

	if use data; then
		emake DESTDIR="${D}" install-data || die "Failed to install data files"
	fi

	if use static-libs; then
		emake \
			DESTDIR="${D}" \
			install-lib-sta || die "Install of static library failed"
	fi
}
