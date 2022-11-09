# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_TEST="test:unit"

RUBY_FAKEGEM_TASK_DOC="doc man"
RUBY_FAKEGEM_EXTRADOC="README.markdown"

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Implementation of John Gruber's Markdown"
HOMEPAGE="https://github.com/rtomayko/rdiscount"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE=""

all_ruby_prepare() {
	# Hanna is broken for us and therefore we don't have it in portage.
	sed -i -e 's/hanna/rdoc/' Rakefile || die

	# Remove rule that will force a rebuild when running tests.
	sed -i -e "/task 'test:unit' => \[:build\]/d" Rakefile || die

	# Provide RUBY variable no longer provided by rake.
	sed -i -e "1 iRUBY=${RUBY}" Rakefile || die

	# Remove obsolete -rubygems argument, bug 775377
	sed -i -e '/-rubygems/ s:^:#:' Rakefile || die
}

all_ruby_install() {
	all_fakegem_install

	doman man/rdiscount.1
}
