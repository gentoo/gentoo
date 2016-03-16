# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="sprockets.gemspec"

inherit ruby-fakegem versionator

DESCRIPTION="Ruby library for compiling and serving web assets"
HOMEPAGE="https://github.com/rails/sprockets"
SRC_URI="https://github.com/rails/sprockets/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1)"
KEYWORDS="~amd64 ~arm"

IUSE=""

ruby_add_rdepend "
	dev-ruby/concurrent-ruby:1
	=dev-ruby/rack-1*:*
	!!<dev-ruby/sprockets-2.12.3-r1:2"

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
	sed -i -e '/.ejs/ s:^:#:' test/test_asset.rb || die
	rm -f test/test_require.rb test/test_{closure,eco,ejs,yui}_{compressor,processor}.rb || die
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
