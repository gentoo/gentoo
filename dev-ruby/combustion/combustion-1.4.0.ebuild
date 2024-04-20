# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"
RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
inherit ruby-fakegem

DESCRIPTION="Elegant Rails Engine Testing"
HOMEPAGE="https://github.com/pat/combustion"
SRC_URI="https://github.com/pat/combustion/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"

ruby_add_rdepend "
	>=dev-ruby/activesupport-3.0.0:*
	>=dev-ruby/railties-3.0.0:*
	>=dev-ruby/thor-0.14.6:*
"
# Needed for e.g. cannot load such file -- action_mailer/railtie
ruby_add_bdepend "
	test? (
		>=dev-ruby/activemodel-3.0.0:*
		>=dev-ruby/activerecord-3.0.0:*
		dev-ruby/bundler
		dev-ruby/net-smtp
		>=dev-ruby/rails-3.0.0:*
		dev-ruby/rspec:3
		>=dev-ruby/sqlite3-1.4
	)
"

each_ruby_prepare() {
	sed -i \
		-e '/rubocop/d' \
		Gemfile || die

	# appraisal, rubocop: useless for us test deps
	# mysql2, pg,: optional runtime deps
	sed -i \
		-e '/appraisal/d' \
		-e '/mysql2/d' \
		-e '/pg/d' \
		-e '/rubocop/d' \
		${PN}.gemspec || die

	sed -i -e '/rubocop/d' Rakefile || die
}

each_ruby_test() {
	local -x DB_ADAPTER=sqlite3
	${RUBY} -S bundle exec rake spec || die
}
