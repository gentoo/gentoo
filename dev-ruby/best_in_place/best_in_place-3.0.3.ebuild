# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/best_in_place/best_in_place-3.0.3.ebuild,v 1.1 2015/07/04 19:46:43 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

# if ever needed
#GITHUB_USER="bernat"
#GITHUB_PROJECT="${PN}"
#RUBY_S="${GITHUB_USER}-${GITHUB_PROJECT}-*"

inherit virtualx ruby-fakegem

DESCRIPTION="In-place editor helper for Rails 3"
HOMEPAGE="https://github.com/bernat/best_in_place"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/actionpack-3.2:*
	>=dev-ruby/railties-3.2:*
"

ruby_add_bdepend "
	test? (
		dev-ruby/rdiscount
		dev-ruby/rspec-rails:3
		>=dev-ruby/nokogiri-1.5.0
		>=dev-ruby/capybara-1.1.2:0
		dev-ruby/poltergeist
		>=dev-ruby/rails-3.2
		>=dev-ruby/sqlite3-1.3.4-r1
		dev-ruby/launchy
		dev-ruby/bundler
	)"

all_ruby_prepare() {
	sed -i \
		-e '/git ls-files/d' \
		${RUBY_FAKEGEM_GEMSPEC} || die

	# Tweak Gemfile so we can use it to run specs but can avoid missing
	# dependencies. Also use packaged versions of jquery and jquery-ui.
	sed -i -e '/\(rails-assets\|appraisal\)/ s:^:#:' \
		-e '2agem "rspec", "~>3.0"' \
		-e '2agem "jquery-rails"' -e '2agem "jquery-ui-rails"' \
		Gemfile
}

each_ruby_test() {
	${RUBY} -S bundle exec rspec-3 spec || die
}
