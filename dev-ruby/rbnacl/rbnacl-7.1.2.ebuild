# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"
RUBY_FAKEGEM_GEMSPEC="rbnacl.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Provides a high-level toolkit for building cryptographic systems and protocols"
HOMEPAGE="https://github.com/RubyCrypto/rbnacl"
SRC_URI="https://github.com/RubyCrypto/rbnacl/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="6"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 x86"
IUSE="test"

RDEPEND=" dev-libs/libsodium"
DEPEND=" test? ( dev-libs/libsodium )"

ruby_add_rdepend "dev-ruby/ffi"

all_ruby_prepare() {
	sed -e 's/__dir__/"."/' \
		-e 's/git ls-files/find * -print/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '/coveralls/I s:^:#:' \
		-e '/bundler/ s:^:#:' \
		-e 's:rbnacl/libsodium:rbnacl:' spec/spec_helper.rb || die
}
