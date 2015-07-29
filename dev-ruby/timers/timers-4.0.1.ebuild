# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/timers/timers-4.0.1.ebuild,v 1.4 2015/07/29 18:35:39 grobian Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

inherit ruby-fakegem

DESCRIPTION="Pure Ruby one-shot and periodic timers"
HOMEPAGE="https://github.com/tarcieri/timers"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "dev-ruby/hitimes"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/bundler/ s:^:#:' spec/spec_helper.rb || die
	sed -i -e '/coveralls/ s:^:#:' spec/spec_helper.rb || die
	sed -i -e '/Coveralls/ s:^:#:' spec/spec_helper.rb || die

	# Remove performance spec due to dependencies and being to dependent
	# on machine specifics.
	rm spec/performance_spec.rb

	# Remove rspec3 configuration so we can still run with rspec2.
	sed -e '/expose/ s:^:#:' -i spec/spec_helper.rb || die
}
