# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/google/protobuf_c/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/google

inherit ruby-fakegem

PARENT_PN="${PN/google-/}"
PARENT_PV="${PV}"
PARENT_P="${PARENT_PN}-${PARENT_PV}"

SRC_URI="
	https://github.com/protocolbuffers/protobuf/archive/v${PARENT_PV}.tar.gz
		-> ${PARENT_P}.tar.gz
"
KEYWORDS="~amd64"

DESCRIPTION="Google's Protocol Buffers - Ruby bindings"
HOMEPAGE="
	https://developers.google.com/protocol-buffers/
"

LICENSE="BSD"
SLOT="0/31"

RUBY_S="${PARENT_P}/ruby"

BDEPEND+="
	dev-libs/protobuf:${SLOT}
"

DEPEND+=" test? ( >=dev-libs/protobuf-${PARENT_PV} )"

all_ruby_prepare() {
	sed -e '/extensiontask/ s:^:#:' \
		-e '/ExtensionTask/,/^  end/ s:^:#:' \
		-e 's:../src/protoc:protoc:' \
		-e 's/:compile,//' \
		-e '/:test/ s/:build,//' \
		-i Rakefile || die
	# Remove unnecessary test
	sed \
		-e "/^  unless ENV\['IN_DOCKER'\]/,/^  end/ s:^:#:" \
		-e '/FileUtils\./ s:^#::' \
		-i Rakefile || die
}
