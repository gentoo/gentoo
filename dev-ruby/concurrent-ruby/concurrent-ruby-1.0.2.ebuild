# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC=""

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Modern concurrency tools including agents, futures, promises, thread pools, more"
HOMEPAGE="https://github.com/ruby-concurrency/concurrent-ruby"
SRC_URI="https://github.com/ruby-concurrency/concurrent-ruby/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~arm ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

all_ruby_prepare() {
	# Remove edge files as defined in support/file_map.rb
	rm -rf {lib,spec}/concurrent/{actor,channel,edge}* \
	   lib/concurrent/{concurrent-edge,lazy_register.rb} \
		spec/concurrent/lazy_register_spec.rb || die
	sed -i -e '/concurrent-edge/ s:^:#:' spec/spec_helper.rb || die

	# Remove specs for the ext gem
	rm -rf spec/concurrent/atomic || die

	sed -i -e '/file_map/d' -e '/s.files/d' ${RUBY_FAKEGEM_GEMSPEC} || die
}
