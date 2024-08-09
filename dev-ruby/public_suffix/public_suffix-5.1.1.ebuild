# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRAINSTALL="data"
RUBY_FAKEGEM_GEMSPEC="public_suffix.gemspec"
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Parse and decompose a domain name into top level domain, domain and subdomains"
HOMEPAGE="https://simonecarletti.com/code/publicsuffix-ruby/"
SRC_URI="https://github.com/weppos/publicsuffix-ruby/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="publicsuffix-ruby-${PV}"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

ruby_add_bdepend "test? ( dev-ruby/mocha:2 )"

all_ruby_prepare() {
	sed -e 's:_relative ": "./:' \
		-e 's/__dir__/"."/' \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '/rubocop/I s:^:#:' \
		-e '/yard/,/CLOBBER.include/ s:^:#:' \
		-e '/bundler/ s:^:#:' Rakefile || die
	sed -i -e '/reporters/I s:^:#:' test/test_helper.rb || die
}
