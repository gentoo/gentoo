# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

# RUBY_FAKEGEM_RECIPE_TEST="rspec3"
# RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_EXTENSIONS="ext/grpc/extconf.rb"
RUBY_FAKEGEM_EXTENSION_LIBDIR="ext/grpc/lib/${PN}"
RUBY_FAKEGEM_GEMSPEC="../../${PN}.gemspec"
RUBY_S="${P}/src/ruby"

inherit ruby-fakegem

DESCRIPTION="Ruby implementation of gRPC"
HOMEPAGE="https://grpc.io/"
SRC_URI="https://github.com/grpc/grpc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/32.155"
KEYWORDS="~amd64"

RDEPEND="
	=dev-cpp/abseil-cpp-20230125.3*:=
	>=dev-libs/re2-0.2021.11.01:=
	>=dev-libs/openssl-1.1.1:0=[-bindist(-)]
	>=dev-libs/protobuf-3.18.1:=
	dev-libs/xxhash
	>=net-dns/c-ares-1.15.0:=
	sys-libs/zlib:=
"

ruby_add_rdepend "
	>=dev-ruby/google-protobuf-3.23
	>=dev-ruby/googleapis-common-protos-types-1.0
"

ruby_add_bdepend "
	test? (
		>=dev-ruby/bundler-1.9
		>=dev-ruby/facter-2.4
		>=dev-ruby/logging-2.0
		>=dev-ruby/simplecov-0.22
		>=dev-ruby/rake-13.0.0
		>=dev-ruby/rake-compiler-1.2.1
		>=dev-ruby/rake-compiler-dock-1.3
		>=dev-ruby/rspec-3.6
		>=dev-ruby/rubocop-1.41.0
		>=dev-ruby/signet-0.7
		>=dev-ruby/googleauth-0.5.1
		<dev-ruby/googleauth-0.10
	)
"

all_ruby_prepare() {
	sed \
		-e "/EMBED_/ s/= .*$/= 'false'/g" \
		-e 's/c++14/c++17/g' \
		-i ext/grpc/extconf.rb || die
	sed \
		-e '/EMBED_/ s/true/false/g' \
		-e 's/c++14/c++17/g' \
		-i ../../Rakefile || die
	sed \
		-e '/^GRPC_ABSEIL_DEP/ s:^:#:' \
		-e '/^GRPC_ABSEIL_MERGE_LIBS/ s:^:#:' \
		-e '/^LIBGRPC_ABSEIL_SRC/,/^$/ s/^/#/' \
		-e 's: -Ithird_party/abseil-cpp::g' \
		-e '/^RE2_DEP/ s:^:#:' \
		-e '/^RE2_MERGE_LIBS/ s:^:#:' \
		-e '/^LIBRE2_SRC/,/^$/ s/^/#/' \
		-e 's: -Ithird_party/re2::g' \
		-e 's/c++14/c++17/g' \
		-i ../../Makefile || die
	sed \
		-e 's:src/ruby/::g' \
		-i ../../grpc.gemspec || die
}
