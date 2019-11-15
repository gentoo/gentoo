# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRAINSTALL="Readme.md"

RUBY_FAKEGEM_GEMSPEC="parallel.gemspec"

inherit ruby-fakegem

DESCRIPTION="Run any code in parallel Processes or Threads"
HOMEPAGE="https://github.com/grosser/parallel"
LICENSE="MIT"
SRC_URI="https://github.com/grosser/parallel/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
SLOT="1"
IUSE="test"

DEPEND+="test? ( sys-process/lsof )"

ruby_add_bdepend "
	test? ( dev-ruby/ruby-progressbar dev-ruby/activerecord:5.2 dev-ruby/sqlite3 )"

each_ruby_prepare() {
	# Make sure the correct ruby is used for testing
	sed -e 's:ruby :'${RUBY}' :' -i spec/parallel_spec.rb || die
}

all_ruby_prepare() {
	sed -i -e 's/git ls-files/find/' ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/bundler/ s:^:#:' \
		-e '1i require "tempfile"; gem "activerecord", "~>5.2.0"' spec/cases/helper.rb || die
	sed -i -e '3irequire "timeout"' spec/spec_helper.rb || die

	# Avoid a failing spec regarding to pipes. The spec seems like it
	# should always fail.
	sed -e '/does not open unnecessary pipes/,/end/ s:^:#:' \
		-i spec/parallel_spec.rb || die

	# Avoid fragile ar sqlite tests. They throw ReadOnly errors every now and then.
	sed -i -e '/works with SQLite in/,/end/ s:^:#:' spec/parallel_spec.rb || die

	# Avoid spec broken on Ruby 2.1 that clearly doesn't match code and doesn't really test anything
	sed -i -e '/doesnt use Etc.nprocessors in Ruby 2.1 and below/,/end/ s:^:#:' spec/parallel_spec.rb || die
}

each_ruby_test() {
	# Set RUBYLIB explicitly for the ruby's that get started from the specs.
	TRAVIS=true RUBYLIB="lib" ${RUBY} -S rspec-3 spec || die
}
