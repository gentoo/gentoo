# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="sprockets.gemspec"

inherit ruby-fakegem

DESCRIPTION="Ruby library for compiling and serving web assets"
HOMEPAGE="https://github.com/rails/sprockets"
SRC_URI="https://github.com/rails/sprockets/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE=""

ruby_add_rdepend "
	dev-ruby/concurrent-ruby:1
	>=dev-ruby/rack-1:* <dev-ruby/rack-3:*
	!<dev-ruby/sprockets-3.7.2-r1:3"

ruby_add_bdepend "test? (
		dev-ruby/json
		dev-ruby/rack-test
		=dev-ruby/coffee-script-2*
		=dev-ruby/execjs-2*
		=dev-ruby/sass-3* >=dev-ruby/sass-3.1
		dev-ruby/uglifier
	)"

all_ruby_prepare() {
	# Avoid tests for template types that we currently don't package:
	# eco and ejs.
	sed -i -e '/eco templates/,/end/ s:^:#:' \
		-e '/ejs templates/,/end/ s:^:#:' test/test_environment.rb || die
	sed -i -e '/.ejs/ s:^:#:' -e '/\(es6_asset.js\|traceur.es6\)/ s:^:#:' test/test_asset.rb || die
	sed -i -e '/compile babel source map/askip' test/test_source_maps.rb || die
	sed -e '/change jst template namespace/askip' \
		-e '/find_asset. does not raise an exception/askip' \
		-e '/es6 asset/askip' \
		-i test/test_environment.rb || die
	rm -f test/test_require.rb test/test_{babel,closure,eco,ejs,jsminc,yui}_{compressor,processor}.rb || die
	# Fails only within Gentoo test environment, not clear why
	sed -i -e '/extension exporters/a skip' test/test_exporting.rb || die
	sed -i -e "/bundler/d" Rakefile || die
}

each_ruby_prepare() {
	sed -i -e "s:ruby:${RUBY}:" test/test_sprocketize.rb || die
}

each_ruby_test() {
	# Make sure we have completely separate copies. Hardlinks won't work
	# for this test suite.
	cp -R test test-new || die
	rm -rf test || die
	mv test-new test || die

	each_fakegem_test
}
