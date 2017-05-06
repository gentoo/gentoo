# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Behaviour Driven Development (BDD) framework for Ruby"
HOMEPAGE="https://github.com/rspec/rspec-support"
SRC_URI="https://github.com/rspec/${PN}/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/rspec-3.5.0:3 dev-ruby/thread_order )"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Remove spec that, by following symlinks, tries to scan pretty much
	# the whole filesystem.
	rm spec/rspec/support/caller_filter_spec.rb || die

	# Avoid spec that requires a dependency on git
	sed -i -e '/library wide checks/,/]/ s:^:#:' spec/rspec/support_spec.rb || die

	# Avoid a spec requiring a specific locale
	sed -i -e '/copes with encoded strings/ s/RSpec::Support::OS.windows?/true/' spec/rspec/support/differ_spec.rb || die
}
