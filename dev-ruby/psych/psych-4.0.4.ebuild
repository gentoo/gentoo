# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTENSIONS=(ext/psych/extconf.rb)
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A YAML parser and emitter"
HOMEPAGE="https://github.com/ruby/psych"

LICENSE="BSD-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE="test"

RDEPEND+=" >=dev-libs/libyaml-0.2.5"
BDEPEND+=" >=dev-libs/libyaml-0.2.5"

ruby_add_rdepend "dev-ruby/stringio"

each_ruby_test() {
	${RUBY} -Ilib:.:test -e 'Dir["test/**/test_*.rb"].each{|f| require f}' || die
}
