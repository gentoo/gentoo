# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/google/protobuf_c/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/google

inherit ruby-fakegem

PROTOBUF_PV="$(ver_cut 2-)"

DESCRIPTION="Protocol Buffers are Google's data interchange format"
HOMEPAGE="https://protobuf.dev/"
SRC_URI="
		https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_PV}/${PN##google-}-${PROTOBUF_PV}.tar.gz
"
RUBY_S="protobuf-${PROTOBUF_PV}/ruby"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-3)"
KEYWORDS="~amd64 ~arm64"
IUSE="test"

DEPEND=">=dev-libs/protobuf-${PROTOBUF_PV}"

ruby_add_bdepend "test? ( dev-ruby/json dev-ruby/test-unit )"

all_ruby_prepare() {
	sed -e '/extensiontask/ s:^:#:' \
		-e '/ExtensionTask/,/^  end/ s:^:#:' \
		-e 's:../src/protoc:protoc:' \
		-e 's/:compile,//' \
		-e '/:test/ s/:build,//' \
		-i Rakefile || die
}

each_ruby_prepare() {
	${RUBY} -S rake genproto || die
	${RUBY} -S rake copy_third_party || die
}
