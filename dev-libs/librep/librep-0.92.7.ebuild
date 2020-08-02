# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools elisp-common flag-o-matic

DESCRIPTION="Shared library implementing a Lisp dialect"
HOMEPAGE="https://sawfish.fandom.com/"
SRC_URI="https://download.tuxfamily.org/librep/${PN}_${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="emacs gmp readline"

RDEPEND="
	>=sys-libs/gdbm-1.8.0
	emacs? ( >=app-editors/emacs-23.1:* )
	gmp? ( dev-libs/gmp:= )
	readline? ( sys-libs/readline:0= )
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.92.0-disable-elisp.patch
)

S="${WORKDIR}/${PN}_${PV}"

src_prepare() {
	# fix #570072 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89
	default

	# The configure script is missing from this version.
	eautoreconf
}

src_configure() {
	econf \
		$(use_with gmp) \
		$(use_with readline) \
		--disable-static \
		--libexecdir=/usr/$(get_libdir) \
		--without-ffi
}

src_compile() {
	default

	if use emacs; then
		elisp-compile rep-debugger.el || die "elisp-compile failed"
	fi
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die

	find "${D}/usr/share/man" -name '*.gz' -exec gunzip {} \; || die

	dodoc doc/*

	if use emacs; then
		elisp-install ${PN} rep-debugger.{el,elc} || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/50${PN}-gentoo.el" \
			|| die "elisp-site-file-install failed"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
