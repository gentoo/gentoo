# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/google/protobuf_c/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/google

inherit ruby-fakegem

PARENT_PN="${PN/google-/}"
PARENT_PV="$(ver_cut 2-)"
PARENT_P="${PARENT_PN}-${PARENT_PV}"

DESCRIPTION="Protocol Buffers are Google's data interchange format"
HOMEPAGE="https://developers.google.com/protocol-buffers"
SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PARENT_PV}.tar.gz -> ${PARENT_P}.tar.gz"
RUBY_S="${PARENT_P}/ruby"

LICENSE="BSD"
SLOT=$(ver_cut 1)
KEYWORDS="~amd64"
IUSE=""

BDEPEND="
	test? (
		dev-libs/protobuf:0/23.3.0
	)
"

ruby_add_bdepend "
	test? (
		>=dev-ruby/rake-compiler-1.1.0
		>=dev-ruby/rake-compiler-dock-1.2.1
		>=dev-ruby/test-unit-3.0.9
	)
"

all_ruby_prepare() {
	mkdir -p 'ext/google/protobuf_c/third_party/utf8_range'
	for i in LICENSE naive.c range2-neon.c range2-sse.c utf8_range.h; do
		cp "../third_party/utf8_range/${i}" 'ext/google/protobuf_c/third_party/utf8_range/'
	done
	sed -e '/:test/ s/:build, //' \
		-i Rakefile || die
}
