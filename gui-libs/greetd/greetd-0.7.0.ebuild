# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
arc-swap-0.4.6
async-trait-0.1.31
bitflags-1.2.1
bytes-0.5.4
cc-1.0.53
cfg-if-0.1.10
enquote-1.0.3
fnv-1.0.7
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
getopts-0.2.21
iovec-0.1.4
itoa-0.4.5
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.70
log-0.4.8
memchr-2.3.3
mio-0.6.22
mio-named-pipes-0.1.6
mio-uds-0.6.8
miow-0.2.1
miow-0.3.3
net2-0.2.34
nix-0.17.0
pam-sys-0.5.6
pin-project-lite-0.1.5
proc-macro2-1.0.12
quote-1.0.5
redox_syscall-0.1.56
rpassword-4.0.5
ryu-1.0.4
serde-1.0.110
serde_derive-1.0.110
serde_json-1.0.53
signal-hook-registry-1.2.0
slab-0.4.2
socket2-0.3.12
syn-1.0.21
thiserror-1.0.17
thiserror-impl-1.0.17
tokio-0.2.11
tokio-macros-0.2.4
unicode-width-0.1.7
unicode-xid-0.2.0
users-0.9.1
void-1.0.2
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
ws2_32-sys-0.2.1
"

inherit cargo optfeature systemd

DESCRIPTION="ipc based login daemon"

HOMEPAGE="https://git.sr.ht/~kennylevinsen/greetd/"
SRC_URI="https://git.sr.ht/~kennylevinsen/greetd/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
"

LICENSE="Apache-2.0 BSD Boost-1.0 GPL-3 MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
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
	dobin target/release/{agreety,fakegreet,greetd}

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
