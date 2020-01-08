# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic toolchain-funcs multilib

DESCRIPTION="Computer-aided number theory C library and tools"
HOMEPAGE="http://pari.math.u-bordeaux.fr/"
LICENSE="GPL-2"
SLOT="0/5"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE="data doc fltk gmp X"
SRC_URI="http://pari.math.u-bordeaux.fr/pub/${PN}/unix/${P}.tar.gz"

RDEPEND="
	sys-libs/readline:0=
	data? ( sci-mathematics/pari-data )
	doc? ( X? ( x11-misc/xdg-utils ) )
	fltk? ( x11-libs/fltk:1= )
	gmp? ( dev-libs/gmp:0= )
	X? ( x11-libs/libX11:0= )"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

get_compile_dir() {
	pushd "${S}/config" > /dev/null
	local fastread=yes
	source ./get_archos
	popd > /dev/null
	echo "O${osname}-${arch}"
}

PATCHES=( "${FILESDIR}"/${P}-strip.patch
		"${FILESDIR}"/${P}-ppc.patch
		"${FILESDIR}"/${P}-no-automagic.patch
		"${FILESDIR}"/${P}-fltk-detection.patch
		)

src_prepare() {
	default

	# disable default building of docs during install
	sed -i \
		-e "s:install-doc install-examples:install-examples:" \
		config/Makefile.SH || die "Failed to fix makefile"

	# propagate ldflags
	sed -i \
		-e 's/$shared $extra/$shared $extra \\$(LDFLAGS)/' \
		config/get_dlld || die "failed to fix LDFLAGS"
	# move doc dir to a gentoo doc dir and replace acroread by xdg-open
	sed -i \
		-e "s:\$d = \$0:\$d = '${EPREFIX}/usr/share/doc/${PF}':" \
		-e 's:"acroread":"xdg-open":' \
		doc/gphelp.in || die "Failed to fix doc dir"
}

src_configure() {
	tc-export CC
	export CPLUSPLUS=$(tc-getCXX)

	# need to force optimization here, as it breaks without
	if is-flag -O0; then
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
		--with-readline="${EPREFIX}"/usr \
		--with-ncurses-lib="${EPREFIX}"/usr/$(get_libdir) \
		$(use_with fltk) \
		$(use_with gmp) \
		--without-qt \
		|| die "./Configure failed"
}

src_compile() {
	use hppa && \
		mymake=DLLD\="${EPREFIX}"/usr/bin/gcc\ DLLDFLAGS\=-shared\ -Wl,-soname=\$\(LIBPARI_SONAME\)\ -lm

	mycxxmake=LD\=$(tc-getCXX)

	local installdir=$(get_compile_dir)
	cd "${installdir}" || die "failed to change directory"
	# upstream set -fno-strict-aliasing.
	# aliasing is a known issue on amd64, work on x86 by sheer luck
	emake ${mymake} \
		CFLAGS="${CFLAGS} -fno-strict-aliasing -DGCC_INLINE -fPIC" lib-dyn
	emake ${mymake} ${mycxxmake} \
		CFLAGS="${CFLAGS} -DGCC_INLINE" gp ../gp

	if use doc; then
		pushd "${S}" > /dev/null || die "failed to change directory"
		VARTEXFONTS="${T}"/fonts emake -j1 docpdf
		popd > /dev/null || die
	fi
}

src_test() {
	emake dobench
}

src_install() {
	emake ${mymake} ${mycxxmake} DESTDIR="${D}" install
	dodoc MACHINES COMPAT
	if use doc; then
		# install gphelp and the pdf documentations manually.
		# the install-doc target is overkill.
		dodoc doc/*.pdf
		dobin doc/gphelp
		insinto /usr/share/doc/${PF}
		# gphelp looks for some of the tex sources...
		doins doc/*.tex doc/translations
		# Install the examples - for real.
		emake EXDIR="${ED}/usr/share/doc/${PF}/examples" \
			-C $(get_compile_dir) install-examples
	fi
}
