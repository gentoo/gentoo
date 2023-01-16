# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/antoniodiazdiaz.asc
inherit edo toolchain-funcs unpacker verify-sig

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="Your basic line editor"
HOMEPAGE="https://www.gnu.org/software/ed/"
SRC_URI="
	mirror://gnu/ed/${MY_P}.tar.lz
	https://download.savannah.gnu.org/releases/ed/${MY_P}.tar.lz
	verify-sig? (
		mirror://gnu/ed/${MY_P}.tar.lz.sig
		https://download.savannah.gnu.org/releases/ed/${MY_P}.tar.lz.sig
	)
"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2+"
SLOT="0"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

# We don't use unpacker_src_uri_depends here right now because:
# 1. unpacker_src_uri_depends doesn't flatten the deps (bug #891133) and emits
# several || ( ... ) blocks (4).
# 2. Portage doesn't handle several repeated identical || ( ...) blocks correctly
# and takes ages to resolve (bug #891137). It should merge them together.
BDEPEND="
	sys-apps/texinfo
	|| (
		>=app-arch/xz-utils-5.4.0
		app-arch/plzip
		app-arch/pdlzip
		app-arch/lzip
	)
	verify-sig? ( sec-keys/openpgp-keys-antoniodiazdiaz )
"

src_unpack() {
	use verify-sig && verify-sig_verify_detached "${DISTDIR}"/${MY_P}.tar.lz{,.sig}
	unpacker "${DISTDIR}"/${MY_P}.tar.lz
}

src_configure() {
	edo ./configure \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		--bindir="${EPREFIX}/bin" \
		--prefix="${EPREFIX}/usr"
}
