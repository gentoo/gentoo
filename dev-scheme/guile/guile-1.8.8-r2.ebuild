# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils autotools flag-o-matic elisp-common

DESCRIPTION="Scheme interpreter"
HOMEPAGE="https://www.gnu.org/software/guile/"
SRC_URI="mirror://gnu/guile/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug debug-freelist debug-malloc +deprecated discouraged emacs networking nls readline +regex +threads"

RESTRICT="!regex? ( test )"

RDEPEND="
	>=dev-libs/gmp-4.1:0=
	dev-libs/libltdl:0=
	sys-devel/gettext
	sys-libs/ncurses:0=
	emacs? ( virtual/emacs )
	readline? ( sys-libs/readline:0= )"
DEPEND="${RDEPEND}
	sys-apps/texinfo
	sys-devel/libtool"

# Guile seems to contain some slotting support, /usr/share/guile/ is slotted,
# but there are lots of collisions. Most in /usr/share/libguile. Therefore
# I'm slotting this in the same slot as guile-1.6* for now.
SLOT="12"
MAJOR="1.8"

src_prepare() {
	epatch "${FILESDIR}/${P}-fix_guile-config.patch" \
		"${FILESDIR}/${P}-gcc46.patch" \
		"${FILESDIR}/${P}-gcc5.patch" \
		"${FILESDIR}/${P}-makeinfo-5.patch" \
		"${FILESDIR}/${P}-gtexinfo-5.patch" \
		"${FILESDIR}/${P}-readline.patch" \
		"${FILESDIR}/${P}-tinfo.patch" \
		"${FILESDIR}/${P}-sandbox.patch"

	sed \
		-e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g" \
		-e "/AM_PROG_CC_STDC/d" \
		-i guile-readline/configure.in

	epatch_user

	mv "${S}"/configure.{in,ac} || die
	mv "${S}"/guile-readline/configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	# see bug #178499
	filter-flags -ftree-vectorize

	#will fail for me if posix is disabled or without modules -- hkBst
	econf \
		--disable-error-on-warning \
		--disable-static \
		--enable-posix \
		$(use_enable networking) \
		$(use_enable readline) \
		$(use_enable regex) \
		$(use deprecated || use_enable discouraged) \
		$(use_enable deprecated) \
		$(use_enable emacs elisp) \
		$(use_enable nls) \
		--disable-rpath \
		$(use_enable debug-freelist) \
		$(use_enable debug-malloc) \
		$(use_enable debug guile-debug) \
		$(use_with threads) \
		--with-modules \
		EMACS=no
}

src_compile()  {
	emake

	# Above we have disabled the build system's Emacs support;
	# for USE=emacs we compile (and install) the files manually
	if use emacs; then
		cd emacs
		elisp-compile *.el || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS ChangeLog GUILE-VERSION HACKING NEWS README THANKS

	# texmacs needs this, closing bug #23493
	dodir /etc/env.d
	echo "GUILE_LOAD_PATH=\"${EPREFIX}/usr/share/guile/${MAJOR}\"" > "${ED}"/etc/env.d/50guile

	# necessary for registering slib, see bug 206896
	keepdir /usr/share/guile/site

	if use emacs; then
		elisp-install ${PN} emacs/*.{el,elc} || die
		elisp-site-file-install "${FILESDIR}/50${PN}-gentoo.el" || die
	fi
}

pkg_postinst() {
	[ "${EROOT}" == "/" ] && pkg_config
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}

pkg_config() {
	if has_version dev-scheme/slib; then
		einfo "Registering slib with guile"
		install_slib_for_guile
	fi
}

_pkg_prerm() {
	rm -f "${EROOT}"/usr/share/guile/site/slibcat
}
