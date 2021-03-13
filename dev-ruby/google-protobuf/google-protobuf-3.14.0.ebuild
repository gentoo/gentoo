# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/google/protobuf_c/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/google

inherit ruby-fakegem

DESCRIPTION="Protocol Buffers are Google's data interchange format"
HOMEPAGE="https://developers.google.com/protocol-buffers"
SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz -> ${P}-ruby.tar.gz"
RUBY_S="protobuf-${PV}/ruby"

LICENSE="BSD"
SLOT="3"
KEYWORDS="~amd64"
IUSE=""

DEPEND+=" test? ( >=dev-libs/protobuf-3.12.0 )"

all_ruby_prepare() {
	sed -e '/extensiontask/ s:^:#:' \
		-e '/ExtensionTask/,/^  end/ s:^:#:' \
		-e 's:../src/protoc:protoc:' \
		-e 's/:compile,//' \
		-i Rakefile || die
}
