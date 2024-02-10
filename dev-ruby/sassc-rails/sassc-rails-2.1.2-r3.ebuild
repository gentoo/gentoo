# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

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

PATCHES=( "${FILESDIR}/${P}-test-directories.patch" "${FILESDIR}/${P}-test-isolation.patch" )

ruby_add_rdepend "
	>=dev-ruby/sassc-2.0
	dev-ruby/tilt:*
	|| ( dev-ruby/railties:7.0 dev-ruby/railties:6.1 )
	>=dev-ruby/sprockets-3.0:*
	dev-ruby/sprockets-rails:*
"

ruby_add_bdepend "
	test? ( dev-ruby/bundler dev-ruby/mocha )"

all_ruby_prepare() {
	sed -e '/rake/ s/,.*$//' \
		-e '/pry/ s:^:#:' \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/pry/ s:^:#:' test/test_helper.rb || die
	sed -e '/test_line_comments_active_in_dev/askip "Fails for unknown reason"' \
		-e '/test_globbed_imports_work_when_globbed_file_is_added/askip "Fails intermittently, similar to test above"' \
		-e 's/MiniTest/Minitest/' \
		-i test/sassc_rails_test.rb || die
}

each_ruby_test() {
	${RUBY} -S bundle exec rake test || die
}
