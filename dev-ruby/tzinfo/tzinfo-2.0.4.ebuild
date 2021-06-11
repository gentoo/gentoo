# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_TASK_TEST="test_zoneinfo"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

RUBY_FAKEGEM_GEMSPEC="tzinfo.gemspec"

inherit ruby-fakegem

DESCRIPTION="Daylight-savings aware timezone library"
HOMEPAGE="https://tzinfo.github.io/"
SRC_URI="https://github.com/tzinfo/tzinfo/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="sys-libs/timezone-data"
DEPEND="test? ( sys-libs/timezone-data )"

ruby_add_rdepend "dev-ruby/concurrent-ruby:1"
ruby_add_bdepend "test? ( dev-ruby/bundler dev-ruby/minitest:5 )"

all_ruby_prepare() {
	# Set the secure permissions that tests expect.
	chmod 0755 "${HOME}" || die "Failed to fix permissions on home"

	# Skip safe tests since we cannot guarantee the correct permissions
	# on directories for it to pass.
	sed -e '/safe_test/askip "does not pass in gentoo test environment"' -i test/test_utils.rb || die

	# Loosen test dependencies
	sed -e '/rake/ s/12.2.1/12.2/' \
		-e '/simplecov/d' \
		-i Gemfile || die
	sed -e '/TEST_COVERAGE/d' -i Rakefile || die
}

each_ruby_test() {
	${RUBY} -S bundle exec rake test || die
}
