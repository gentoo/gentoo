# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Ruby bindings for the stomp messaging protocol"
HOMEPAGE="https://github.com/stompgem/stomp"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.10-rspec-3.12.patch
)

all_ruby_prepare() {
	# Skip specs that hang the test run indefinitely, most likely
	# because of rspec-mocks deprecation output
	rm -f spec/connection_spec.rb || die
}
