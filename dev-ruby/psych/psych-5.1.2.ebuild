# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTENSIONS=(ext/psych/extconf.rb)
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="psych.gemspec"

inherit ruby-fakegem

DESCRIPTION="A YAML parser and emitter"
HOMEPAGE="https://github.com/ruby/psych"
SRC_URI="https://github.com/ruby/psych/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
SLOT="$(ver_cut 1)"
IUSE="test"

RDEPEND+=" >=dev-libs/libyaml-0.2.5"
BDEPEND+=" >=dev-libs/libyaml-0.2.5"

ruby_add_rdepend "dev-ruby/stringio"

ruby_add_bdepend "test? (
	dev-ruby/test-unit
	dev-ruby/test-unit-ruby-core
)"

all_ruby_prepare() {
	sed -e 's/__dir__/"."/' \
		-i ${RUBY_FAKEGEM_GEMSPEC}
}

each_ruby_test() {
	${RUBY} -Ilib:.:test -e 'require "lib/helper"; Dir["test/**/test_*.rb"].each{|f| require f}' || die
}
