# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31"

#RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_S="${P}/src/ruby"
RUBY_FAKEGEM_EXTENSIONS="ext/grpc/extconf.rb"
RUBY_FAKEGEM_EXTENSION_LIBDIR="ext/grpc/lib/${PN}"
RUBY_FAKEGEM_GEMSPEC="../../${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Ruby implementation of gRPC"
HOMEPAGE="https://grpc.io/"
SRC_URI="https://github.com/grpc/grpc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# not really needed but it solves deps for now
#DEPENDS+="net-libs/grpc"

RDEPEND="
	=dev-cpp/abseil-cpp-20220623.1*:=
	>=dev-libs/re2-0.2021.11.01:=
	>=dev-libs/openssl-1.1.1:0=[-bindist(-)]
	>=dev-libs/protobuf-3.18.1:=
	dev-libs/xxhash
	>=net-dns/c-ares-1.15.0:=
	sys-libs/zlib:=
"

ruby_add_rdepend "
	>=dev-ruby/google-protobuf-3.23
	>=dev-ruby/googleapis-common-protos-types-1.0.0
"

all_ruby_prepare() {
	sed -e '/EMBED_/ s:^:#:' -i ext/grpc/extconf.rb || die
	sed -e '/^GRPC_ABSEIL_DEP/ s:^:#:' \
		-e '/^GRPC_ABSEIL_MERGE_LIBS/ s:^:#:' \
		-e '/^RE2_DEP/ s:^:#:' \
		-e '/^RE2_MERGE_LIBS/ s:^:#:' \
		-e '/^LIBGRPC_ABSEIL_SRC/,/^$/ s:^:#:' \
		-e '/^LIBRE2_SRC/,/^$/ s:^:#:' \
		-e 's/-Ithird_party\/re2//g' \
		-e 's/-Ithird_party\/abseil-cpp//g' \
		-e 's/-Ithird_party\/xxhash//g' \
		-i ../../Makefile || die
	sed -e 's/src\/ruby\///g' -i ../../grpc.gemspec || die
}
