# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

inherit ruby-fakegem

DESCRIPTION="Provides a simple and natural way to build fault-tolerant concurrent programs"
HOMEPAGE="https://github.com/celluloid/celluloid"
SRC_URI="https://github.com/celluloid/celluloid-essentials/archive/v${PV}.tar.gz -> ${P}.tar.gz"
IUSE=""
SLOT="0"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

ruby_add_rdepend "
	>=dev-ruby/timers-4.1.1"

ruby_add_bdepend "test? (
	dev-ruby/celluloid
	dev-ruby/dotenv
	dev-ruby/nenv
	dev-ruby/rspec-retry
)"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' -e '/coveralls/I s:^:#:' spec/spec_helper.rb || die

	sed -i -e '1irequire "pathname"' spec/spec_helper.rb || die
	sed -i -e "s:log/test.log:${TMPDIR}/test.log:" .env-dev || die
}
