# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
${PN}@${PV}
anyhow@1.0.26
ansi_term@0.11.0
aho-corasick@1.1.4
android-tzdata@0.1.1
android_system_properties@0.1.5
arrayvec@0.7.6
atty@0.2.14
autocfg@1.5.0
backtrace@0.3.37
backtrace@sys-0.1.31
base64@0.22.1
bindgen@0.72.1
bitflags@1.3.2
bitflags@2.10.0
boring@4.19.0
boring-sys@4.19.0
bstr@0.2.12
bumpalo@3.17.0
byteorder@1.3.4
cast@0.2.3
cc@1.2.52
cdylib-link-lines@0.1.5
cexpr@0.6.0
cfg-if@0.1.10
cfg-if@1.0.4
chrono@0.4.40
clang-sys@1.8.1
clap@2.33.3
cmake@0.1.57
core-foundation-sys@0.8.7
criterion@0.3.1
criterion@plot-0.4.1
crossbeam@deque-0.7.3
crossbeam@epoch-0.8.2
crossbeam@queue-0.2.1
crossbeam@utils-0.7.2
csv@1.1.3
csv@core-0.1.10
data-encoding@2.10.0
darling@0.21.3
darling_core@0.21.3
darling_macro@0.21.3
data@encoding-2.3.3
debug_panic@0.2.1
deranged@0.4.1
displaydoc@0.2.5
enum_dispatch@0.3.13
either@1.15.0
env_logger@0.8.4
equivalent@1.0.2
find-msvc-tools@0.1.7
fnv@1.0.7
foreign-types@0.5.0
foreign-types-macros@0.2.3
foreign-types-shared@0.3.1
form_urlencoded@1.2.2
fuchsia-zircon@0.3.3
fuchsia-zircon-sys@0.3.3
fs_extra@1.3.0
fslock@0.2.1
futures-core@0.3.31
futures-macro@0.3.31
futures-task@0.3.31
futures-timer@3.0.3
futures-util@0.3.31
getrandom@0.2.17
glob@0.3.3
hashbrown@0.12.3
hashbrown@0.15.5
hashbrown@0.16.1
hermit@abi-0.1.19
hex@0.4.3
humantime@2.1.0
iana-time-zone-haiku@0.1.2
iana-time-zone@0.1.63
icu_collections@2.1.1
icu_locale_core@2.1.1
icu_locid@1.5.0
icu_locid_transform_data@1.5.1
icu_locid_transform@1.5.0
icu_normalizer@2.1.1
icu_normalizer_data@2.1.1
icu_properties@2.1.2
icu_properties_data@2.1.2
icu_provider@2.1.1
icu_provider_macros@1.5.0
ident_case@1.0.1
idna@1.1.0
idna_adapter@1.2.1
intrusive-collections@0.9.7
iovec@0.1.4
itertools@0.13.0
itoa@1.0.17
js-sys@0.3.77
kernel32-sys@0.2.2
lazycell@1.3.0
lazy_static@1.5.0
libc@0.2.180
libloading@0.8.9
libm@0.2.15
litemap@0.8.1
log@0.4.29
matches@0.1.10
maybe-uninit@2.0.0
memchr@2.7.6
memoffset@0.9.1
minimal-lexical@0.2.1
mio@1.1.1
miow@0.4.0
net2@0.2.37
nom@7.1.3
num-conv@0.1.0
num-traits@0.2.19
num_cpus@1.12.0
octets@0.3.4
openssl-macros@0.1.1
peeking_take_while@0.1.2
pin-project-lite@0.2.16
pin-utils@0.1.0
indexmap@1.9.3
indexmap@2.13.0
once_cell@1.21.3
oorandom@11.1.0
percent-encoding@2.3.2
pkg-config@0.3.32
plotters@0.2.12
potential_utf@0.1.4
powerfmt@0.2.0
proc-macro-crate@3.4.0
proc-macro2@1.0.105
qlog@0.15.2
quote@1.0.43
rayon@1.3.0
rayon@core-1.7.0
regex@1.12.2
regex-automata@0.4.13
regex-syntax@0.8.8
relative-path@1.9.3
ring@0.17.14
rstest@0.26.1
rstest_macros@0.26.1
rustc_version@0.4.1
rustc-hash@2.1.1
rustversion@1.0.20
rust_decimal@1.40.0
ryu@1.0.20
same-file@1.0.6
scopeguard@1.1.0
sfv@0.9.4
semver@1.0.27
semver-parser@0.7.0
serde@1.0.228
serde_core@1.0.228
serde_derive@1.0.228
serde_json@1.0.149
serde_with@3.16.1
serde_with_macros@3.16.1
shlex@1.3.0
slab@0.4.11
smallvec@1.15.1
spin@0.9.8
stable_deref_trait@1.2.1
strsim@0.8.0
strsim@0.11.1
syn@1.0.109
syn@2.0.114
synstructure@0.13.2
termcolor@1.1.2
textwrap@0.11.0
time@0.3.41
time-core@0.1.4
time-macros@0.2.22
tinystr@0.8.2
tinytemplate@1.0.3
tinyvec@1.6.1
tinyvec_macros@0.1.1
toml_datetime@0.7.5+spec-1.1.0
toml_edit@0.23.10+spec-1.0.0
toml_parser@1.0.6+spec-1.1.0
unicode-bidi@0.3.15
unicode-ident@1.0.22
unicode-normalization@0.1.23
unicode-width@0.1.10
unicode-xid@0.2.4
unicode-xid@0.2.3
untrusted@0.9.0
url@2.5.8
utf8_iter@1.0.4
utf16_iter@1.0.5
vec_map@0.8.2
version_check@0.9.4
walkdir@2.3.1
wasm-bindgen@0.2.100
wasm-bindgen-backend@0.2.100
wasm-bindgen-macro@0.2.100
wasm-bindgen-macro-support@0.2.100
wasm-bindgen-shared@0.2.100
wasm-bindgen-webidl@0.2.75
wasi@0.11.1+wasi-snapshot-preview1
web-sys@0.3.65
which@3.1.1
winapi@0.2.8
winapi@0.3.9
winapi-build@0.1.1
winapi-i686-pc-windows-gnu@0.4.0
winapi-util@0.1.5
winapi-x86_64-pc-windows-gnu@0.4.0
windows-core@0.61.0
windows_aarch64_gnullvm@0.48.5
windows_aarch64_gnullvm@0.52.6
windows_aarch64_gnullvm@0.53.0
windows_aarch64_msvc@0.48.5
windows_aarch64_msvc@0.52.6
windows_aarch64_msvc@0.53.0
windows_i686_gnu@0.48.5
windows_i686_gnu@0.52.6
windows_i686_gnu@0.53.0
windows_i686_gnullvm@0.52.6
windows_i686_gnullvm@0.53.0
windows_i686_msvc@0.48.5
windows_i686_msvc@0.52.6
windows_i686_msvc@0.53.0
windows_x86_64_gnu@0.48.5
windows_x86_64_gnu@0.52.6
windows_x86_64_gnu@0.53.0
windows_x86_64_gnullvm@0.48.5
windows_x86_64_gnullvm@0.52.6
windows_x86_64_gnullvm@0.53.0
windows_x86_64_msvc@0.48.5
windows_x86_64_msvc@0.52.6
windows_x86_64_msvc@0.53.0
windows-implement@0.60.0
windows-interface@0.59.1
windows-sys@0.48.0
windows-sys@0.52.0
windows-sys@0.59.0
windows-sys@0.61.2
windows-targets@0.53.0
windows-targets@0.53.3
windows-targets@0.52.6
windows-targets@0.48.5
windows-link@0.2.1
windows-result@0.3.2
windows-strings@0.4.0
winnow@0.7.14
write16@1.0.0
writeable@0.6.2
ws2_32-sys@0.2.1
yoke@0.8.1
yoke-derive@0.8.1
zerofrom@0.1.6
zerofrom-derive@0.1.6
zerotrie@0.2.3
zerovec@0.11.5
zerovec-derive@0.11.2
zmij@1.0.14
"

RUST_MULTILIB=1

inherit cargo cmake flag-o-matic multilib-minimal

DESCRIPTION="Implementation of the QUIC transport protocol and HTTP/3"
HOMEPAGE="https://github.com/cloudflare/quiche"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/cloudflare/${PN}.git"
	inherit git-r3
	CMAKE_USE_DIR="${S}/quiche/deps/boringssl"
else
	SRC_URI="${CARGO_CRATE_URIS}"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
	S="${WORKDIR}/${P//_/-}"
	CMAKE_USE_DIR="${S}/deps/boringssl"
fi

LICENSE="|| ( Apache-2.0 Boost-1.0 )
	|| ( Apache-2.0 MIT )
	|| ( Apache-2.0-with-LLVM-exceptions Apache-2.0 MIT )
	BSD-2
	BSD
	ISC
	MIT
	|| ( Unlicense MIT )
	openssl"
SLOT="0/0"
IUSE=""
DOCS=( COPYING README.md )

BDEPEND="
	dev-build/cmake
"
DEPEND=""
RDEPEND=""

BUILD_DIR="${WORKDIR}/${P}"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
		tar -xf "${DISTDIR}/${P//_/-}.crate" -C "${WORKDIR}" || die
	fi
}

src_prepare() {
	cmake_src_prepare
	multilib_copy_sources
}

src_configure() {
	multilib-minimal_src_configure
}

multilib_src_configure() {
	append-flags "-fPIC"
	local mycmakeargs=(
		-DOPENSSL_NO_ASM=ON
		-DBUILD_SHARED_LIBS=OFF
	)
	BUILD_DIR="${BUILD_DIR}/deps/boringssl/build" cmake_src_configure
}

src_compile() {
	multilib-minimal_src_compile
}

multilib_src_compile() {
	BUILD_DIR="${BUILD_DIR}/deps/boringssl/build" cmake_src_compile bssl
	QUICHE_BSSL_PATH="${BUILD_DIR}/deps/boringssl" cargo_src_compile --features "ffi pkg-config-meta"
}

src_test() {
	multilib-minimal_src_test
}

multilib_src_test() {
	QUICHE_BSSL_PATH="${BUILD_DIR}/deps/boringssl" cargo_src_test
}

src_install() {
	multilib-minimal_src_install
}

multilib_src_install() {
	sed -i -e "s:libdir=.\+:libdir=${EPREFIX}/usr/$(get_libdir):" -e "s:includedir=.\+:includedir=${EPREFIX}/usr/include:" "$(cargo_target_dir)"/quiche.pc || die
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "$(cargo_target_dir)"/quiche.pc
	doheader -r include/*
	dolib.so "$(cargo_target_dir)"/libquiche.so
	QA_FLAGS_IGNORED+=" usr/$(get_libdir)/libquiche.so" # rust libraries don't use LDFLAGS
	QA_SONAME+=" usr/$(get_libdir)/libquiche.so" # https://github.com/cloudflare/quiche/issues/165
}
