# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Integrate SassC-Ruby with Rails"
HOMEPAGE="https://github.com/sass/sassc-rails"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"

IUSE=""

ruby_add_rdepend "
	>=dev-ruby/sassc-2.0
	dev-ruby/tilt:*
	|| ( dev-ruby/railties:5.2 dev-ruby/railties:6.0 dev-ruby/railties:6.1 )
	>=dev-ruby/sprockets-3.0:*
	dev-ruby/sprockets-rails:*
"

ruby_add_bdepend "
	test? ( dev-ruby/bundler dev-ruby/mocha )"

all_ruby_prepare() {
	sed -e '/rake/ s/,.*$//' \
		-e '/pry/ s:^:#:' \
		-e "/railties/ s/$/, '<7'/" \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/pry/ s:^:#:' test/test_helper.rb || die
}

each_ruby_test() {
	${RUBY} -S bundle exec rake test || die
}
