# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="Changelog README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A framework to implement robust multiprocess servers"
HOMEPAGE="https://github.com/treasure-data/serverengine"
LICENSE="Apache-2.0"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/sigdump-0.2.2:0"

ruby_add_bdepend "test? ( dev-ruby/bundler >=dev-ruby/rr-3.1:0 dev-ruby/timecop )"

all_ruby_prepare() {
	sed -i -e '/rake/ s/~>/>=/' \
		-e '/rspec/ s/3.12.0/3.12/' \
		-e '/rake-compiler/ s:^:#:' serverengine.gemspec || die

	sed -i -e '/color_enabled/ s:^:#:' -e '1irequire "fileutils"' spec/spec_helper.rb || die

	sed -i -e '/raises SystemExit/askip "Exits rspec 3"' spec/multi_process_server_spec.rb || die
}

each_ruby_test() {
	# The specs spawn ruby processes with bundler support
	${RUBY} -S bundle exec rspec-3 spec || die
}
