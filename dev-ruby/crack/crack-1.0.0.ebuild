# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="README.md History"

RUBY_FAKEGEM_GEMSPEC="crack.gemspec"

inherit ruby-fakegem

DESCRIPTION="Really simple JSON and XML parsing, ripped from Merb and Rails"
HOMEPAGE="https://github.com/jnunemaker/crack"
SRC_URI="https://github.com/jnunemaker/crack/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_rdepend "dev-ruby/bigdecimal dev-ruby/rexml"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e 's/git ls-files --/find/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Itest -Ilib -e 'Dir["test/*_test.rb"].each { |f| load f }' || die
}
