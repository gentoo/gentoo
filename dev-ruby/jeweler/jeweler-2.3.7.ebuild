# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC="-Ilib yard"
RUBY_FAKEGEM_DOCDIR="doc"

# Tests and features also need the same set of dependencies present.
RUBY_FAKEGEM_TASK_TEST="-Ilib test"

RUBY_FAKEGEM_EXTRADOC="ChangeLog.markdown README.markdown"

RUBY_FAKEGEM_GEMSPEC="jeweler.gemspec"

inherit ruby-fakegem

DESCRIPTION="Rake tasks to manage gems, versioning and generate new projects"
HOMEPAGE="https://wiki.github.com/technicalpickles/jeweler"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "
	doc? ( dev-ruby/yard )
	test? (
		  dev-ruby/shoulda
		  dev-ruby/rr
		  dev-ruby/test-unit-rr
		  dev-ruby/test_construct
		  dev-ruby/test-unit:2
	)
"

ruby_add_rdepend "
	dev-ruby/builder:*
	>=dev-ruby/bundler-1.0
	>=dev-ruby/git-1.2.5
	>=dev-ruby/github_api-0.16.0
	>=dev-ruby/highline-1.6.15
	>=dev-ruby/nokogiri-1.5.10
	dev-ruby/psych:0
	dev-ruby/rake
	dev-ruby/rdoc
	dev-ruby/semver2
"

all_ruby_prepare() {
	# Remove bundler support.
	rm Gemfile || die
	sed -i -e '/bundler/d' -e '/Bundler.setup/d' Rakefile test/test_helper.rb features/support/env.rb || die

	sed -i -e '/coverall/I s:^:#:' \
		-e '1i gem "test-unit"' test/test_helper.rb || die

	# Avoid a test that only passes in the git repository.
	sed -i -e '/find the base repo/,/^  end/ s:^:#:' test/test_jeweler.rb || die

	# Avoid dependency on cucumber, make sure semver2 gem is used (puppet also provides "semver")
	sed -i -e '/cucumber/,$ s:^:#:' \
		-e '1igem "semver2"' Rakefile || die

	# Loosen github_api requirement
	sed -i -e '/github_api/ s/0.16.0/0.16/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
