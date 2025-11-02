# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler2@2.0.0
	aho-corasick@1.1.3
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.6
	anstyle@1.0.10
	base64@0.22.1
	bincode@1.3.3
	bindgen@0.69.5
	bit-set@0.5.3
	bit-vec@0.6.3
	bitflags@1.3.2
	bitflags@2.6.0
	bon-macros@3.3.2
	bon@3.3.2
	bumpalo@3.16.0
	caseless@0.2.1
	cc@1.2.6
	cexpr@0.6.0
	cfg-if@1.0.0
	clang-sys@1.8.1
	clap@4.5.23
	clap_builder@4.5.23
	clap_derive@4.5.18
	clap_lex@0.7.4
	colorchoice@1.0.3
	comrak@0.38.0
	crc32fast@1.4.2
	darling@0.20.10
	darling_core@0.20.10
	darling_macro@0.20.10
	deranged@0.3.11
	deunicode@1.6.0
	either@1.13.0
	emojis@0.6.4
	entities@1.0.1
	equivalent@1.0.1
	errno@0.3.10
	fancy-regex@0.11.0
	flate2@1.0.35
	fnv@1.0.7
	glob@0.3.2
	hashbrown@0.15.2
	heck@0.5.0
	ident_case@1.0.1
	indexmap@2.7.0
	is_terminal_polyfill@1.70.1
	itertools@0.12.1
	itoa@1.0.14
	lazy_static@1.5.0
	lazycell@1.3.0
	libc@0.2.169
	libloading@0.8.6
	linked-hash-map@0.5.6
	linux-raw-sys@0.4.14
	log@0.4.22
	magnus-macros@0.6.0
	magnus@0.7.1
	memchr@2.7.4
	minimal-lexical@0.2.1
	miniz_oxide@0.8.2
	nom@7.1.3
	num-conv@0.1.0
	once_cell@1.20.2
	onig@6.4.0
	onig_sys@69.8.1
	phf@0.11.2
	phf_shared@0.11.2
	pkg-config@0.3.31
	plist@1.7.0
	powerfmt@0.2.0
	prettyplease@0.2.25
	proc-macro2@1.0.92
	quick-xml@0.32.0
	quote@1.0.38
	rb-sys-build@0.9.111
	rb-sys-env@0.1.2
	rb-sys@0.9.111
	rctree@0.6.0
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rustc-hash@1.1.0
	rustix@0.38.42
	rustversion@1.0.19
	ryu@1.0.18
	same-file@1.0.6
	seq-macro@0.3.5
	serde@1.0.217
	serde_derive@1.0.217
	serde_json@1.0.134
	shell-words@1.1.0
	shlex@1.3.0
	siphasher@0.3.11
	slug@0.1.6
	strsim@0.11.1
	syn@2.0.93
	syntect@5.2.0
	terminal_size@0.4.1
	thiserror-impl@1.0.69
	thiserror@1.0.69
	time-core@0.1.2
	time-macros@0.2.19
	time@0.3.37
	tinyvec@1.8.1
	tinyvec_macros@0.1.1
	typed-arena@2.0.2
	unicode-ident@1.0.14
	unicode-normalization@0.1.24
	unicode_categories@0.1.1
	utf8parse@0.2.2
	walkdir@2.5.0
	wasm-bindgen-backend@0.2.99
	wasm-bindgen-macro-support@0.2.99
	wasm-bindgen-macro@0.2.99
	wasm-bindgen-shared@0.2.99
	wasm-bindgen@0.2.99
	winapi-util@0.1.9
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	xdg@2.5.2
	yaml-rust@0.4.5
"

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTENSIONS=(ext/commonmarker/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/commonmarker"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="commonmarker.gemspec"

inherit cargo flag-o-matic ruby-fakegem

DESCRIPTION="A fast, safe, extensible parser for CommonMark, wrapping the comrak Rust crate"
HOMEPAGE="https://github.com/gjtorikian/commonmarker"
SRC_URI="https://github.com/gjtorikian/commonmarker/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" ${CARGO_CRATE_URIS}"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD-2 BSD ISC MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-libs/oniguruma:="
DEPEND="${RDEPEND} llvm-core/clang"

ruby_add_bdepend ">=dev-ruby/rb_sys-0.9:0"

all_ruby_prepare() {
	cargo_src_unpack

	# Tests fail when using the system oniguruma, bug 951737.
	# export RUSTONIG_SYSTEM_LIBONIG=1

	# Needed for the bundled oniguruma source code in the onig_sys crate.
	append-flags -std=gnu17

	sed -i -e '/focus/ s:^:#:' test/test_helper.rb || die
}

each_ruby_prepare() {
	# Use current ruby version
	sed -i -e '/make_bin/,/end/ s:ruby:'${RUBY}':' test/test_helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/*_test.rb"].each {|f| require f}' || die
}
