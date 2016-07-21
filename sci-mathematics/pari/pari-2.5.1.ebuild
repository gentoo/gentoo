# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="A software package for computer-aided number theory"
HOMEPAGE="http://pari.math.u-bordeaux.fr/"
SRC_URI="http://pari.math.u-bordeaux.fr/pub/${PN}/unix/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE="doc data fltk gmp X"

RDEPEND="sys-libs/readline
	fltk? ( x11-libs/fltk:1 )
	gmp? ( dev-libs/gmp )
	X? ( x11-libs/libX11 )
	doc? ( X? ( x11-misc/xdg-utils ) )
	data? ( sci-mathematics/pari-data )"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

get_compile_dir() {
	pushd "${S}/config" > /dev/null
	local fastread=yes
	source ./get_archos
	popd > /dev/null
	echo "O${osname}-${arch}"
}

src_prepare() {
	epatch "${FILESDIR}/${PN}"-2.3.2-strip.patch
	epatch "${FILESDIR}/${PN}"-2.3.2-ppc-powerpc-arch-fix.patch
	# fix parallel make
	epatch "${FILESDIR}/${PN}"-2.5.0-doc-make.patch
	# sage error handling patch
	epatch "${FILESDIR}/${PN}"-2.5.0-mp.c.patch
	# OS X: add -install_name to the linker option
	epatch "${FILESDIR}/${PN}"-2.5.0-macos.patch
	# from debian, fies bug #423617
	epatch "${FILESDIR}/${PN}"-2.5.1-gcc47.patch

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

	sed -i "s:/usr:${EPREFIX}/usr:g" config/get_X11 \
		|| die "Failed to fix get_X11"

	# usersch3.tex is generated
	rm -f doc/usersch3.tex || die "failed to remove generated file"
}

src_configure() {
	tc-export CC

	# need to force optimization here, as it breaks without
	if is-flag -O0; then
		replace-flags -O0 -O2
	elif ! is-flag -O?; then
		append-flags -O2
	fi

	local myconfig
	if use gmp ; then
		myconfig="--with-gmp=${EPREFIX}/usr"
	else
		myconfig="--with-gmp=no"
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
		$myconfig \
		|| die "./Configure failed"
}

src_compile() {
	local installdir=$(get_compile_dir)
	cd "${installdir}" || die "failed to change directory"

	# upstream set -fno-strict-aliasing.
	# aliasing is a known issue on amd64, work on x86 by sheer luck
	emake ${mymake} \
		CFLAGS="${CFLAGS} -fno-strict-aliasing -DGCC_INLINE -fPIC" lib-dyn
	emake ${mymake} \
		CFLAGS="${CFLAGS} -DGCC_INLINE" gp ../gp

	if use doc; then
		cd "${S}" || die "failed to change directory"
		# To prevent sandbox violations by metafont
		VARTEXFONTS="${T}"/fonts emake docpdf
	fi
}

src_test() {
	emake dobench
}

src_install() {
	default
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
		local installdir=$(get_compile_dir)
		cd "${installdir}" || die "failed to change directory"
		emake EXDIR="${ED}/usr/share/doc/${PF}/examples" install-examples
	fi
}
