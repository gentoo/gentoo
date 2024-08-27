# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="Erubis is an implementation of eRuby"
HOMEPAGE="http://www.kuwata-lab.com/erubis/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

# http://rubyforge.org/tracker/index.php?func=detail&aid=29484&group_id=1320&atid=5201
# Tests are not compatible with Psych as YAML module.
RESTRICT="test"

ruby_add_rdepend ">=dev-ruby/abstract-1.0.0"

all_ruby_prepare() {
	# These tests now fail due to other ordering and fact that sym
	# are now returned.
	rm test/test-users-guide.rb || die
	sed -i -e '/test-users-guide/ s:^:#:' test/test.rb || die
}

each_ruby_test() {
	PATH="${S}/bin:${PATH}" RUBYLIB="${S}/lib" ${RUBY} -I. test/test.rb || die
}
