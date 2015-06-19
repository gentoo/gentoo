# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/uuidtools/uuidtools-2.1.5.ebuild,v 1.5 2015/04/12 07:10:14 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC="-f tasks/yard.rake doc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

inherit ruby-fakegem

DESCRIPTION="Simple library to generate UUIDs"
HOMEPAGE="https://github.com/sporkmonger/uuidtools"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos"
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
