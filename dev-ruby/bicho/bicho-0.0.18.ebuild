# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="bicho.gemspec"

inherit ruby-fakegem

DESCRIPTION="ruby Bugzilla access library"
HOMEPAGE="https://github.com/dmacvicar/bicho"
SRC_URI="https://github.com/dmacvicar/bicho/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "
	dev-ruby/highline:3
	dev-ruby/inifile:3
	>=dev-ruby/nokogiri-1.10.4:0
	dev-ruby/optimist:3
	>=dev-ruby/xmlrpc-0.3.0 =dev-ruby/xmlrpc-0.3*
"

ruby_add_bdepend "test? (
	dev-ruby/minitest
	dev-ruby/vcr
	dev-ruby/webmock
)"

all_ruby_prepare() {
	# Fix dependencies to adhere to semver
	sed -e '/nokogiri/ s/1.10.4/1.10/' \
		-e '/highline/ s/2.0.0/2.0/' \
		-e '/highline/ s/~>/>=/' \
		-e '/optimist/ s/3.0.0/3.0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid unneeded development dependencies
	sed -i -e '/bundler/ s:^:#:' Rakefile test/helper.rb || die
	sed -i -e '/reporters/ s:^:#: ; /Reporters/,/^)/ s:^:#:' test/helper.rb || die
}
