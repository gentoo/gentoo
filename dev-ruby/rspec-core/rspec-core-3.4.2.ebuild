# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST="none"
RUBY_FAKEGEM_TASK_DOC="none"

RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

# Also install this custom path since internal paths depend on it.
RUBY_FAKEGEM_EXTRAINSTALL="exe"

RUBY_FAKEGEM_GEMSPEC="rspec-core.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Behaviour Driven Development (BDD) framework for Ruby"
HOMEPAGE="https://github.com/rspec/rspec-core"
SRC_URI="https://github.com/rspec/${PN}/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64 ~arm ~hppa ~ppc64"
IUSE="highlight"

SUBVERSION="$(get_version_component_range 1-2)"

ruby_add_rdepend "
	=dev-ruby/rspec-support-${SUBVERSION}*
	!!<dev-ruby/rspec-core-2.14.8-r4
	highlight? ( >=dev-ruby/coderay-1.0.9 )
"

ruby_add_bdepend "test? (
		>=dev-ruby/nokogiri-1.5.2
		>=dev-ruby/coderay-1.0.9
		dev-ruby/syntax
		>=dev-ruby/thread_order-1.1.0
		>=dev-ruby/zentest-4.6.2
		>=dev-ruby/rspec-expectations-3.3.0:3
		>=dev-ruby/rspec-mocks-2.99.0:3
	)"

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
	sed -i -e 's/git ls-files --/find/' rspec-core.gemspec || die

	# Avoid aruba dependency so that we don't end up in dependency hell.
	sed -i -e '/ArubaLoader/,/^end/ s:^:#:' -e '/Aruba/ s:^:#:' spec/spec_helper.rb || die
	rm spec/integration/{failed_line_detection,filtering,order,persistence_failures}_spec.rb spec/support/aruba_support.rb || die

	# Avoid a spec failing due to path issues
	sed -i -e '/does not load files in the default path when run by ruby/,/end/ s:^:#:' \
		spec/rspec/core/configuration_spec.rb || die

	# Avoid specs for older coderay version which is no longer packaged
	sed -i -e '/highlights the syntax of the provided lines/ s/do/,skip: true do/' \
		-e '/dynamically adjusts to changing color config/ s/do/,skip: true do/' \
		spec/rspec/core/source/syntax_highlighter_spec.rb
}

each_ruby_prepare() {
	sed -i -e 's:ruby -e:'${RUBY}' -e:' spec/rspec/core_spec.rb || die

	# case ${RUBY} in
	# 	*ruby22)
	# 		# The rubygems version bundled with ruby 2.2 causes warnings.
	# 		sed -i -e '/a library that issues no warnings when loaded/,/^  end/ s:^:#:' spec/rspec/core_spec.rb || die
	# 		;;
	# esac
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

	ruby_fakegem_binwrapper rspec /usr/bin/rspec-3 'gem "rspec", "~>3.0"'
}
