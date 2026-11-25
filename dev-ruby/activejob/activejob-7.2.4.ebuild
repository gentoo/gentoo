# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_DOC=""

inherit edo ruby-fakegem

DESCRIPTION="Job framework with pluggable queues"
HOMEPAGE="https://github.com/rails/rails"

SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"
RUBY_S="rails-${PV}/${PN}"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~sparc ~x86"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/globalid-0.3.6
"

ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		dev-ruby/minitest:5
		dev-ruby/zeitwerk
	)
"

all_ruby_prepare() {
	# Replace Gemfile with something simpler for the test run
	cat <<-EOF > ../Gemfile || die
	source "https://rubygems.org"
	gemspec

	gem "rake"

	gem "minitest", "~> 5.0"

	gem "zeitwerk"
	EOF
	rm ../Gemfile.lock || die

	# Don't pull in all of rails for tests. Handle it explicitly via Gemfile
	sed -E -e "/s.add_dependency/ { /(${PN}|bundler)/!d }" -i ../rails.gemspec || die

	# Unpackaged
	sed -e '/SneakersAdapter/ s:^:#:' -i test/cases/exceptions_test.rb || die
}

each_ruby_test() {
	# Allow the minitest rails plugin to be found.
	local -x  RUBYLIB=../railties/lib

	local -x BUNDLE_GEMFILE="../Gemfile"
	local -x MT_NO_PLUGINS=true
	edo ${RUBY} -S bundle exec ${RUBY} --disable=did_you_mean -S rake test:test
}
