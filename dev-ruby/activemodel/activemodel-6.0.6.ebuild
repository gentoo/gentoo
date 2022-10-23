# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="activemodel.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Toolkit for building modeling frameworks like Active Record and Active Resource"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}:*
"

ruby_add_bdepend "
	test? (
		~dev-ruby/railties-${PV}
		dev-ruby/test-unit:2
		dev-ruby/mocha
		>=dev-ruby/bcrypt-ruby-3.1.7
		<dev-ruby/minitest-5.16:5
	)"

all_ruby_prepare() {
	# Set test environment to our hand.
	sed -i -e '3igem "psych", "~> 3.0"' test/cases/helper.rb || die "Unable to remove load paths"
}
