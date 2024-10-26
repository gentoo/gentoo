# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="sprockets.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Ruby library for compiling and serving web assets"
HOMEPAGE="https://github.com/rails/sprockets"
SRC_URI="https://github.com/rails/sprockets/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

PATCHES=(
	"${FILESDIR}/${P}-erb-deprecation.patch"
	"${FILESDIR}/${P}-kwargs.patch"
	"${FILESDIR}/${P}-ruby31-host-uri.patch"
)

ruby_add_rdepend "
	dev-ruby/concurrent-ruby:1
	>=dev-ruby/rack-1:* <dev-ruby/rack-3:*"

ruby_add_bdepend "test? (
		dev-ruby/json
		dev-ruby/rack-test
		=dev-ruby/coffee-script-2*
		=dev-ruby/execjs-2*
		dev-ruby/nokogiri
		=dev-ruby/sass-3* >=dev-ruby/sass-3.1
		dev-ruby/uglifier
	)"

all_ruby_prepare() {
	# Avoid tests for template types that we currently don't package:
	# eco and ejs.
	sed -i -e '/eco templates/,/end/ s:^:#:' \
		-e '/ejs templates/,/end/ s:^:#:' test/test_environment.rb || die
	sed -i -e '/.ejs/ s:^:#:' test/test_asset.rb || die
	rm -f test/test_require.rb test/test_{closure,eco,ejs,yui}_{compressor,processor}.rb || die
	sed -i -e "/bundler/d" Rakefile || die

	sed -i -e 's/MiniTest/Minitest/' test/sprockets_test.rb test/test*.rb || die
	sed -i -e '2igem "rack", "<3"' test/sprockets_test.rb || die
	sed -i -e '5irequire "rack/lint"' test/test_server.rb || die
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
