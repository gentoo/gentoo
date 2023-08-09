# Copyright 2017-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	async-trait@0.1.60
	autocfg@1.1.0
	bitflags@1.3.2
	bytes@1.3.0
	cfg-if@1.0.0
	enquote@1.1.0
	getopts@0.2.21
	itoa@1.0.5
	libc@0.2.139
	log@0.4.17
	memchr@2.5.0
	memoffset@0.7.1
	mio@0.8.5
	nix@0.26.1
	pam-sys@0.5.6
	pin-project-lite@0.2.9
	pin-utils@0.1.0
	proc-macro2@1.0.49
	quote@1.0.23
	rpassword@5.0.1
	ryu@1.0.12
	serde@1.0.152
	serde_derive@1.0.152
	serde_json@1.0.91
	signal-hook-registry@1.4.0
	socket2@0.4.7
	static_assertions@1.1.0
	syn@1.0.107
	thiserror-impl@1.0.38
	thiserror@1.0.38
	tokio-macros@1.8.2
	tokio@1.24.0
	unicode-ident@1.0.6
	unicode-width@0.1.10
	users@0.11.0
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.42.0
	windows_aarch64_gnullvm@0.42.0
	windows_aarch64_msvc@0.42.0
	windows_i686_gnu@0.42.0
	windows_i686_msvc@0.42.0
	windows_x86_64_gnu@0.42.0
	windows_x86_64_gnullvm@0.42.0
	windows_x86_64_msvc@0.42.0
"

inherit cargo optfeature systemd

DESCRIPTION="ipc based login daemon"

HOMEPAGE="https://git.sr.ht/~kennylevinsen/greetd/"
SRC_URI="https://git.sr.ht/~kennylevinsen/greetd/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT Unicode-DFS-2016 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="man"

DEPEND="
	acct-user/greetd
	sys-auth/pambase
	sys-libs/pam
"
RDEPEND="${DEPEND}"
BDEPEND="man? ( app-text/scdoc )"

QA_FLAGS_IGNORED="usr/bin/.*greet.*"

PATCHES=(
	"${FILESDIR}/${PN}-0.6.1-correct_user_config_toml.patch"
)

src_compile() {
	cargo_src_compile
	if use man; then
		scdoc < ./man/agreety-1.scd > ./agreety.1 || die
		scdoc < ./man/greetd-1.scd > ./greetd.1 || die
		scdoc < ./man/greetd-5.scd > ./greetd.5 || die
		scdoc < ./man/greetd-ipc-7.scd > ./greetd-ipc.7 || die
	fi
}

src_install() {
	# if USE=debug, install binaries from the debug directory; else
	# install binaries from the release directory
	# https://bugs.gentoo.org/889052
	dobin target/$(usex debug debug release)/{agreety,fakegreet,greetd}

	insinto /etc/greetd
	doins config.toml

	systemd_dounit greetd.service

	if use man; then
		doman agreety.1 greetd.1 greetd.5 greetd-ipc.7
	fi
}

pkg_postint() {
	optfeature "eye-candy gtk based greeter" gui-apps/gtkgreet
	optfeature "simplistic but sleek terminal greeter" gui-apps/tuigreet
}
