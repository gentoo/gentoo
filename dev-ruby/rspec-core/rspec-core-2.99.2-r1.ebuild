# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rspec-core/rspec-core-2.99.2-r1.ebuild,v 1.2 2015/02/21 09:37:16 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST="none"
RUBY_FAKEGEM_TASK_DOC="none"

RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

# Also install this custom path since internal paths depend on it.
RUBY_FAKEGEM_EXTRAINSTALL="exe"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="rspec-core.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Behaviour Driven Development (BDD) framework for Ruby"
HOMEPAGE="http://github.com/rspec/rspec-core"
SRC_URI="https://github.com/rspec/${PN}/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? (
		>=dev-ruby/nokogiri-1.5.2
		dev-ruby/syntax
		>=dev-ruby/zentest-4.6.2
		>=dev-ruby/rspec-expectations-2.14.0:2
		>=dev-ruby/rspec-mocks-2.99.0:2
	)"

# Skip yard for ruby21 for now since we don't support ruby21 eselected
# yet and we can't bootstrap otherwise.
USE_RUBY=${USE_RUBY/ruby21 ruby22/} ruby_add_bdepend "doc? ( dev-ruby/yard )"

all_ruby_prepare() {
	# Don't set up bundler: it doesn't understand our setup.
	sed -i -e '/[Bb]undler/d' Rakefile || die

	# Avoid dependency on cucumber since we can't run the features anyway.
	sed -i -e '/[Cc]ucumber/ s:^:#:' Rakefile || die

	# Duplicate exe also in bin. We can't change it since internal stuff
	# also depends on this and fixing that is going to be fragile. This
	# way we can at least install proper bin scripts.
	cp -R exe bin || die

	# Avoid unneeded dependency on git.
	sed -i -e '/git ls-files/ s:^:#:' rspec-core.gemspec || die

	# Avoid aruba dependency so that we don't end up in dependency hell.
	sed -i -e '/aruba/ s:^:#:' -e '/Aruba/,/}/ s:^:#:' spec/spec_helper.rb || die
	rm spec/command_line/order_spec.rb || die
}

each_ruby_prepare() {
	sed -i -e 's:ruby -e:'${RUBY}' -e:' spec/rspec/core_spec.rb || die
}

all_ruby_compile() {
	if use doc ; then
		yardoc || die
	fi
}

each_ruby_test() {
	PATH="${S}/bin:${PATH}" RUBYLIB="${S}/lib" ${RUBY} -Ilib bin/rspec spec || die "Tests failed."
}

all_ruby_install() {
	all_fakegem_install

	ruby_fakegem_binwrapper rspec /usr/bin/rspec-2 'gem "rspec", "~>2.0"'
}
