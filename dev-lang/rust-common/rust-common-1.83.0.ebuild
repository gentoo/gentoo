# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/rust.asc
inherit bash-completion-r1 verify-sig

DESCRIPTION="Common files shared between multiple slots of Rust"
HOMEPAGE="https://www.rust-lang.org/"

if [[ ${PV} = *beta* ]]; then
	betaver=${PV//*beta}
	BETA_SNAPSHOT="${betaver:0:4}-${betaver:4:2}-${betaver:6:2}"
	SRC="${BETA_SNAPSHOT}/rustc-beta-src.tar.xz -> rustc-${PV}-src.tar.xz"
else
	ABI_VER="$(ver_cut 1-2)"
	MY_P="rustc-${PV}"
	SRC="${MY_P}-src.tar.xz"
fi

SRC_URI="
	https://static.rust-lang.org/dist/${SRC}
	verify-sig? ( https://static.rust-lang.org/dist/${SRC}.asc )
"
S="${WORKDIR}/${MY_P}-src"

LICENSE="|| ( MIT Apache-2.0 ) BSD BSD-1 BSD-2 BSD-4"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc x86"

# Legacy non-slotted versions bash completions will collide.
RDEPEND="
	!dev-lang/rust:stable
	!dev-lang/rust-bin:stable
"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-rust )"

src_unpack() {
	if use verify-sig ; then
		verify-sig_verify_detached "${DISTDIR}"/${SRC} "${DISTDIR}"/${SRC}.asc
	fi

	# Avoid unpacking the whole tarball which would need check-reqs
	tar -xf "${DISTDIR}"/${SRC} ${SRC%%.tar.xz}/src/tools/cargo/src/etc/cargo.bashcomp.sh || die
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	newbashcomp src/tools/cargo/src/etc/cargo.bashcomp.sh cargo
}
