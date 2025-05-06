# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/rust.asc
inherit shell-completion verify-sig

DESCRIPTION="Common files shared between multiple slots of Rust"
HOMEPAGE="https://www.rust-lang.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	# In case cargo is not in sync we'll fetch it as a submodule
	# Nightly users will probably already have the repo cloned and up-to-date anyway.
	EGIT_REPO_URI="https://github.com/rust-lang/rust.git"
	EGIT_SUBMODULES=( "-*" "src/tools/cargo" )
elif [[ ${PV} == *beta* ]]; then
	# Identify the snapshot date of the beta release:
	# curl -Ls static.rust-lang.org/dist/channel-rust-beta.toml | grep beta-src.tar.xz
	MY_PV=beta
	betaver=${PV//*beta}
	BETA_SNAPSHOT="${betaver:0:4}-${betaver:4:2}-${betaver:6:2}"
	SRC_URI="https://static.rust-lang.org/dist/${BETA_SNAPSHOT}/rustc-beta-src.tar.xz -> rustc-${PV}-src.tar.xz
		verify-sig? ( https://static.rust-lang.org/dist/${BETA_SNAPSHOT}/rustc-beta-src.tar.xz.asc
			-> rustc-${PV}-src.tar.xz.asc )
	"
	S="${WORKDIR}/rustc-${MY_PV}-src"
else
	MY_PV=${PV}
	SRC_URI="https://static.rust-lang.org/dist/rustc-${PV}-src.tar.xz
		verify-sig? ( https://static.rust-lang.org/dist/rustc-${PV}-src.tar.xz.asc )
	"
	S="${WORKDIR}/rustc-${MY_PV}-src"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="|| ( MIT Apache-2.0 ) BSD BSD-1 BSD-2 BSD-4"
SLOT="0"

# Legacy non-slotted versions bash completions will collide.
RDEPEND="
	!dev-lang/rust:stable
	!dev-lang/rust-bin:stable
"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-rust )"

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
	else
		if use verify-sig ; then
			verify-sig_verify_detached "${DISTDIR}"/rustc-${PV}-src.tar.xz "${DISTDIR}"/rustc-${PV}-src.tar.xz.asc
		fi

		# Avoid unpacking the whole tarball which would need check-reqs
		tar -xf "${DISTDIR}"/rustc-${PV}-src.tar.xz \
			"rustc-${MY_PV}-src/src/tools/cargo/src/etc/"{_cargo,cargo.bashcomp.sh} || die
	fi
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	newbashcomp src/tools/cargo/src/etc/cargo.bashcomp.sh cargo
	dozshcomp src/tools/cargo/src/etc/_cargo
}
