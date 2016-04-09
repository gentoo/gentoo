# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="sprockets.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem versionator

DESCRIPTION="Ruby library for compiling and serving web assets"
HOMEPAGE="https://github.com/sstephenson/sprockets"
SRC_URI="https://github.com/sstephenson/sprockets/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="2.11"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE=""

ruby_add_rdepend "
	=dev-ruby/hike-1* >=dev-ruby/hike-1.2
	=dev-ruby/multi_json-1*
	=dev-ruby/rack-1*
	=dev-ruby/tilt-1* >=dev-ruby/tilt-1.3.1
	!!<dev-ruby/sprockets-2.2.2-r1:2.2"

ruby_add_bdepend "test? (
		dev-ruby/json
		dev-ruby/rack-test
		=dev-ruby/coffee-script-2*
		=dev-ruby/execjs-2*
		=dev-ruby/sass-3* >=dev-ruby/sass-3.1
	)"

all_ruby_prepare() {
	# Avoid tests for template types that we currently don't package:
	# eco and ejs.
	sed -i -e '/eco templates/,/end/ s:^:#:' \
		-e '/ejs templates/,/end/ s:^:#:' test/test_environment.rb || die

	# Add missing 'json' require
	sed -i -e '4irequire "json"' test/test_manifest.rb || die

	# Avoid test breaking on specific javascript error being thrown,
	# most likely due to using node instead of v8.
	sed -i -e '/bundled asset cached if theres an error/,/^  end/ s:^:#:' test/test_environment.rb || die

	# Require a newer version of execjs since we do not have this slotted.
	sed -i -e '/execjs/ s/1.0/2.0/' ${RUBY_FAKEGEM_GEMSPEC} || die
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
