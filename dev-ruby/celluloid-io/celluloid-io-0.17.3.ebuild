# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

inherit ruby-fakegem

DESCRIPTION="Evented IO for Celluloid actors"
HOMEPAGE="https://github.com/celluloid/celluloid-io"
IUSE=""
SLOT="0"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

ruby_add_rdepend ">=dev-ruby/celluloid-0.17.3
	>=dev-ruby/nio4r-1.2.1:*
	>=dev-ruby/timers-4.1.1"

ruby_add_bdepend " test? (
		dev-ruby/dotenv
		dev-ruby/nenv
	)"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' -e '/[Cc]overalls/ s:^:#:' \
		-e '2irequire "pathname"; require "fileutils"' spec/spec_helper.rb || die

	# Avoid DNS tests. They either assume localhost is 127.0.0.1 or
	# require network access.
	rm spec/celluloid/io/dns_resolver_spec.rb || die

	# Make sure test logs end up in the right place
	sed -i -e 's:log/test.log:'${T}'/test.log:' .env-dev || die
}
