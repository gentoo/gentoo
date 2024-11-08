# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic elisp-common

DESCRIPTION="GNU Ubiquitous Intelligent Language for Extensions"
HOMEPAGE="https://www.gnu.org/software/guile/"
SRC_URI="mirror://gnu/guile/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug debug-freelist debug-malloc +deprecated discouraged emacs networking nls readline +regex +threads"
RESTRICT="!regex? ( test )"

RDEPEND="
	>=dev-libs/gmp-4.1:0=
	dev-libs/libltdl:0=
	sys-devel/gettext
	sys-libs/ncurses:0=
	virtual/libcrypt:=
	readline? ( sys-libs/readline:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/texinfo
	dev-build/libtool
	emacs? ( >=app-editors/emacs-23.1:* )
"

PATCHES=(
	"${FILESDIR}"/${P}-fix_guile-config.patch
	"${FILESDIR}"/${P}-gcc46.patch
	"${FILESDIR}"/${P}-gcc5.patch
	"${FILESDIR}"/${P}-makeinfo-5.patch
	"${FILESDIR}"/${P}-gtexinfo-5.patch
	"${FILESDIR}"/${P}-readline.patch
	"${FILESDIR}"/${P}-tinfo.patch
	"${FILESDIR}"/${P}-sandbox.patch
	"${FILESDIR}"/${P}-mkdir-mask.patch
	"${FILESDIR}"/${PN}-1.8.8-texinfo-6.7.patch
)

DOCS=( AUTHORS ChangeLog GUILE-VERSION HACKING NEWS README THANKS )

# Where to install data files.
GUILE_DATA="${EPREFIX}/usr/share/guile-data/${SLOT}"
GUILE_PCDIR="${EPREFIX}/usr/share/guile-data/${SLOT}/pkgconfig"
GUILE_INFODIR="${EPREFIX}"/usr/share/guile-data/"${SLOT}"/info

src_prepare() {
	default

	sed \
		-e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g" \
		-e "/AM_PROG_CC_STDC/d" \
		-i guile-readline/configure.in || die

	mv "${S}"/configure.{in,ac} || die
	mv "${S}"/guile-readline/configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	# See bug #178499.  filter-flags no longer works since the compiler
	# will vectorize by default when optimizing.
	append-flags -fno-tree-vectorize -fno-strict-aliasing

	#will fail for me if posix is disabled or without modules -- hkBst
	myconf=(
		--program-suffix="-${SLOT}"
		--infodir="${GUILE_INFODIR}"
		--includedir="${EPREFIX}/usr/include/guile/${SLOT}"

		--disable-error-on-warning
		--disable-static
		--enable-posix
		$(use_enable networking)
		$(use_enable readline)
		$(use_enable regex)
		$(use deprecated || use_enable discouraged)
		$(use_enable deprecated)
		$(use_enable emacs elisp)
		$(use_enable nls)
		--disable-rpath
		$(use_enable debug-freelist)
		$(use_enable debug-malloc)
		$(use_enable debug guile-debug)
		$(use_with threads)
		--with-modules
	)
	econf "${myconf[@]}" EMACS=no
}

src_compile() {
	emake

	# Above we have disabled the build system's Emacs support;
	# for USE=emacs we compile (and install) the files manually
	if use emacs; then
		cd emacs || die
		elisp-compile *.el || die
	fi
}

# Akin to (and taken from) toolchain-autoconfs eclass
guile_slot_info() {
	rm -f dir || die

	pushd "${D}/${GUILE_INFODIR}" >/dev/null || die
	for f in *.info*; do
		# Install convenience aliases for versioned Guile pages.
		ln -s "$f" "${f/./-${SLOT}.}" || die
	done
	popd >/dev/null || die

	docompress "${GUILE_INFODIR}"
}

src_install() {
	default

	dodir "${GUILE_PCDIR}"
	sed -e "/libdir/i bindir=${ESYSROOT}/usr/bin" \
		-e "/libguileinterface/a guile=\${bindir}/guile-${SLOT}" \
		-i "${ED}"/usr/$(get_libdir)/pkgconfig/guile-1.8.pc || die
	mv "${ED}"/usr/$(get_libdir)/pkgconfig/guile-1.8.pc "${D}/${GUILE_PCDIR}"/guile-1.8.pc || die

	sed -i "1s/guile/guile-1.8/" "${ED}"/usr/bin/guile-config-1.8 || die

	for script in PROGRAM autofrisk doc-snarf generate-autoload punify \
				  read-scheme-source scan-api snarf-guile-m4-docs use2dot \
				  api-diff  display-commentary frisk lint read-rfc822 \
				  read-text-outline snarf-check-and-output-texi summarize-guile-TODO; do
		sed "s/GUILE-guile/GUILE-guile-1.8/" \
			-i "${ED}"/usr/share/guile/1.8/scripts/${script}-1.8 || die
		mv "${ED}"/usr/share/guile/1.8/scripts/${script}{-1.8,} || die
	done

	mv "${ED}"/usr/share/aclocal/guile{,-"${SLOT}"}.m4 || die
	find "${ED}" -name '*.la' -delete || die

	guile_slot_info

	local major="$(ver_cut 1 "${SLOT}")"
	local minor="$(ver_cut 2 "${SLOT}")"
	local idx="$((99999-(major*1000+minor)))"
	newenvd - "50guile${idx}" <<-EOF
	PKG_CONFIG_PATH="${GUILE_PCDIR}"
	INFOPATH="${GUILE_INFODIR}"
	EOF

	# necessary for registering slib, see bug 206896
	keepdir /usr/share/guile/site

	if use emacs; then
		elisp-install ${PN}-${SLOT} emacs/*.{el,elc}
		elisp-make-site-file "50${PN}-${SLOT}-gentoo.el"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
