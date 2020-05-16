# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Protocol Buffers are Google's data interchange format"
HOMEPAGE="https://developers.google.com/protocol-buffers"
SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz -> ${P}-ruby.tar.gz"
RUBY_S="protobuf-${PV}/ruby"

LICENSE="BSD"
SLOT="3"
KEYWORDS="~amd64"
IUSE=""

DEPEND+=" test? ( >=dev-libs/protobuf-3.7.0 )"

each_ruby_prepare() {
	sed -i -e 's:../src/protoc:protoc: ; /^task :build/ s/:compile,//' Rakefile || die
}

each_ruby_configure() {
	${RUBY} -Cext/google/protobuf_c extconf.rb
}

each_ruby_compile() {
	emake -Cext/google/protobuf_c V=1
	cp ext/google/protobuf_c/protobuf_c.so lib/google/ || die
}
