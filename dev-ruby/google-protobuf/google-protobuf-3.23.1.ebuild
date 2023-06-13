# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_S="protobuf-${PV}/ruby"
RUBY_FAKEGEM_EXTENSIONS="ext/google/protobuf_c/extconf.rb"
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/google/protobuf"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

#https://github.com/protocolbuffers/protobuf/commit/00c38227bb86230d151c0fd666248cbf61d03bee
PATCHES=("${FILESDIR}/${PN}-build_descriptor_pb.patch")

inherit ruby-fakegem

DESCRIPTION="Protocol Buffers are Google's data interchange format"
HOMEPAGE="https://developers.google.com/protocol-buffers"
SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV}/${PV}.tar.gz -> ${P}-ruby.tar.gz"
# For some reason google now bundles everthing together into one release

LICENSE="BSD"
SLOT="3"
KEYWORDS="~amd64"
IUSE=""

BDEPEND+="test? ( >=dev-libs/protobuf-19.0 )"

all_ruby_prepare() {
	mkdir -p 'ext/google/protobuf_c/third_party/utf8_range'
	cp '../third_party/utf8_range/utf8_range.h' 'ext/google/protobuf_c/third_party/utf8_range'
	cp '../third_party/utf8_range/naive.c' 'ext/google/protobuf_c/third_party/utf8_range'
	cp '../third_party/utf8_range/range2-neon.c' 'ext/google/protobuf_c/third_party/utf8_range'
	cp '../third_party/utf8_range/range2-sse.c' 'ext/google/protobuf_c/third_party/utf8_range'
	cp '../third_party/utf8_range/LICENSE' 'ext/google/protobuf_c/third_party/utf8_range'
	sed -e '/extensiontask/ s:^:#:' \
		-e '/ExtensionTask/,/^  end/ s:^:#:' \
		-e 's/:compile,//' \
		-e '/:test/ s/:build,//' \
		-i Rakefile || die
	sed -e '/\($LDFLAGS += "\)/ s:^:#:' \
		-i ext/google/protobuf_c/extconf.rb || die
	#https://github.com/protocolbuffers/protobuf/issues/11935
}
