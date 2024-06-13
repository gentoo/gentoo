# Copyright 2017-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.21.0
	adler@1.0.2
	async-trait@0.1.80
	backtrace@0.3.71
	bitflags@2.5.0
	bytes@1.6.0
	cc@1.0.95
	cfg-if@1.0.0
	enquote@1.1.0
	getopts@0.2.21
	gimli@0.28.1
	itoa@1.0.11
	libc@0.2.153
	memchr@2.7.2
	miniz_oxide@0.7.2
	mio@0.8.11
	nix@0.27.1
	object@0.32.2
	pam-sys@0.5.6
	pin-project-lite@0.2.14
	proc-macro2@1.0.81
	quote@1.0.36
	rpassword@5.0.1
	rustc-demangle@0.1.23
	ryu@1.0.17
	serde@1.0.198
	serde_derive@1.0.198
	serde_json@1.0.116
	signal-hook-registry@1.4.1
	socket2@0.5.6
	syn@2.0.60
	thiserror-impl@1.0.58
	thiserror@1.0.58
	tokio-macros@2.2.0
	tokio@1.37.0
	unicode-ident@1.0.12
	unicode-width@0.1.11
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.5
"

inherit cargo optfeature pam systemd

DESCRIPTION="ipc based login daemon"

HOMEPAGE="https://git.sr.ht/~kennylevinsen/greetd/"
SRC_URI="https://git.sr.ht/~kennylevinsen/greetd/archive/${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
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
	dobin "$(cargo_target_dir)"/{agreety,fakegreet,greetd}

	insinto /etc/greetd
	doins config.toml

	systemd_dounit greetd.service

	if use man; then
		doman agreety.1 greetd.1 greetd.5 greetd-ipc.7
	fi

	newpamd - greetd <<-EOF
		# newer greetd errors when no greetd-specific pam.d config is
		# available
		# workaround by just using the fallback that it was already
		# using anyway
		auth            include         login
		account         include         login
		password        include         login
		session         include         login
	EOF
}

pkg_postint() {
	optfeature "eye-candy gtk based greeter" gui-apps/gtkgreet
	optfeature "simplistic but sleek terminal greeter" gui-apps/tuigreet
}
