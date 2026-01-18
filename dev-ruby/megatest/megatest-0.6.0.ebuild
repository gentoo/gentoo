# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_BINDIR="exe"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md TODO.md"
RUBY_FAKEGEM_GEMSPEC="megatest.gemspec"

inherit ruby-fakegem

DESCRIPTION="A test-unit like framework with a focus on usability, designed with CI in mind."
HOMEPAGE="https://github.com/byroot/megatest"
SRC_URI="https://github.com/byroot/megatest/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"

all_ruby_prepare() {
	sed -e '/\(bundler\|rubocop\)/I s:^:#:' \
		-i Rakefile || die

	sed -e 's/git ls-files -z/find * -print0/' \
		-e 's:_relative ": "./:' \
		-e 's/__FILE__/"megatest.gemspec"/' \
		-e 's/__dir__/"."/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid testing redis support for now since it is not packaged yet.
	sed -e '/redis_queue/ s:^:#:' \
		-i test/test_helper.rb || die
	rm -f test/megatest/redis_queue_test.rb test/integration/multi_process_integration_test.rb || die
}

each_ruby_test() {
	RUBYLIB=lib ${RUBY} exe/megatest test || die
}
