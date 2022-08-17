# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC="-f tasks/yard.rake doc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

inherit ruby-fakegem

DESCRIPTION="Simple library to generate UUIDs"
HOMEPAGE="https://github.com/sporkmonger/uuidtools"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

ruby_add_bdepend "doc? ( dev-ruby/yard )"

all_ruby_prepare() {
	# Avoid specs that require an actual network interface to get a MAC
	# address. We can't assume that a network interface is available.
	sed -e '/when obtaining a MAC address/,/^end/ s:^:#:' \
		-i spec/uuidtools/mac_address_spec.rb || die
	sed -e '/should correctly generate timestamp variant UUIDs/,/^  end/ s:^:#:' \
		-i spec/uuidtools/uuid_creation_spec.rb || die
	sed -e '/should not treat a timestamp version UUID as a random node UUID/,/^  end/ s:^:#:' \
		-i spec/uuidtools/uuid_parsing_spec.rb || die
}
