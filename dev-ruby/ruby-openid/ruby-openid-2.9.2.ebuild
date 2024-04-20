# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md NOTICE UPGRADE.md"

RUBY_FAKEGEM_GEMSPEC="ruby-openid.gemspec"

inherit ruby-fakegem

DESCRIPTION="A robust library for verifying and serving OpenID identities"
HOMEPAGE="https://github.com/openid/ruby-openid"
SRC_URI="https://github.com/openid/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/webrick )"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die

	# Avoid test failing due to new sematics in ruby 3
	sed -i -e '/test_no_host/askip "Ruby 3 incompatibility"' test/test_discover.rb || die

	# Fix Bignum deprecation in tests
	sed -i -e 's/Bignum/Integer/' test/test_cryptutil.rb || die
}

all_ruby_install() {
	all_fakegem_install

	dodoc -r examples
}
