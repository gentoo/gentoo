# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_GEMSPEC="brotli.gemspec"
RUBY_FAKEGEM_EXTENSIONS=(ext/brotli/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/brotli"

inherit ruby-fakegem

# upstream brotli aggressively strips files from generated git archives. So you need to fetch the test files one by one.
BROTLI_COMMIT="028fb5a23661f123017c060daa546b55cf4bde29"

DESCRIPTION="Brotli compressor/decompressor"
HOMEPAGE="https://github.com/miyucy/brotli"
SRC_URI="
	https://github.com/miyucy/brotli/archive/v${PV}.tar.gz -> ruby-${P}.tar.gz
	test? (
		https://github.com/google/brotli/raw/${BROTLI_COMMIT}/tests/testdata/alice29.txt
			-> brotli-${BROTLI_COMMIT:0:8}-alice29.txt
		https://github.com/google/brotli/raw/${BROTLI_COMMIT}/tests/testdata/alice29.txt.compressed
			-> brotli-${BROTLI_COMMIT:0:8}-alice29.txt.compressed
		https://github.com/google/brotli/raw/${BROTLI_COMMIT}/tests/testdata/zerosukkanooa
			-> brotli-${BROTLI_COMMIT:0:8}-zerosukkanooa
		https://github.com/google/brotli/raw/${BROTLI_COMMIT}/tests/testdata/zerosukkanooa.compressed
			-> brotli-${BROTLI_COMMIT:0:8}-zerosukkanooa.compressed
	)
"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"

DEPEND=">=app-arch/brotli-1.1.0:="
RDEPEND="${DEPEND}"

ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		dev-ruby/rantly:*
		>=dev-ruby/test-unit-3.0
		dev-ruby/test-unit-rr
	)
"

all_ruby_prepare() {
	sed -e 's/__dir__/"."/' \
		-e 's/git ls-files -z/find * -print0/' \
		-e 's:require_relative ":require "./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid rake-compiler, we handle it via the eclass
	sed -e '/rake-compiler/ s:^:#:' \
		-i Gemfile || die
	sed -e '/require "rake\/extensiontask"/ s:^:#:' \
		-e '/Rake::ExtensionTask/,/^end/ s:^:#:' \
		-e '/task build: :compile/ s:^:#:' \
		-e '/task test: :compile/ s:^:#:' \
		-i Rakefile || die

	if use test; then
		mkdir -p vendor/brotli/tests/testdata || die
		cp {"${DISTDIR}"/brotli-${BROTLI_COMMIT:0:8}-,vendor/brotli/tests/testdata/}alice29.txt || die
		cp {"${DISTDIR}"/brotli-${BROTLI_COMMIT:0:8}-,vendor/brotli/tests/testdata/}alice29.txt.compressed || die
		cp {"${DISTDIR}"/brotli-${BROTLI_COMMIT:0:8}-,vendor/brotli/tests/testdata/}zerosukkanooa || die
		cp {"${DISTDIR}"/brotli-${BROTLI_COMMIT:0:8}-,vendor/brotli/tests/testdata/}zerosukkanooa.compressed || die
	fi
}
