# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_TEST="none"

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
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="highlight"

SUBVERSION="$(ver_cut 1-2)"

ruby_add_rdepend "
	=dev-ruby/rspec-support-${SUBVERSION}*
	highlight? ( >=dev-ruby/coderay-1.1.1 )
"

ruby_add_bdepend "test? (
		>=dev-ruby/nokogiri-1.5.2
		>=dev-ruby/coderay-1.1.1
		dev-ruby/syntax
		>=dev-ruby/thread_order-1.1.0
		>=dev-ruby/rspec-expectations-3.8.0:3
		>=dev-ruby/rspec-mocks-2.99.0:3
		>=dev-ruby/rspec-support-3.9.1:3
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
	rm -f spec/support/aruba_support.rb || die
	rm -f spec/integration/{bisect_runners,failed_line_detection,filtering,order,persistence_failures,suite_hooks_errors}_spec.rb || die
	rm -f spec/integration/{spec_file_load_errors,output_stream,fail_if_no_examples}_spec.rb || die

	# Avoid a spec failing due to path issues
	sed -i -e '/does not load files in the default path when run by ruby/,/end/ s:^:#:' \
		spec/rspec/core/configuration_spec.rb || die

	# Avoid a spec that depends on dev-ruby/rspec to lessen circular
	# dependencies, bug 662328
	sed -i -e '/loads mocks and expectations when the constants are referenced/askip "gentoo: bug 662328"' spec/rspec/core_spec.rb || die

	# Avoid a spec depending on specifics on local networks
	# This fails when localhost resolves to ::1 which may be a
	# ruby regression in the drb/acl code.
	rm -f spec/rspec/core/bisect/server_spec.rb || die
}

each_ruby_prepare() {
	sed -i -e 's:ruby -e:'${RUBY}' -e:' spec/rspec/core_spec.rb || die
}

each_ruby_test() {
	PATH="${S}/bin:${PATH}" RUBYLIB="${S}/lib" ${RUBY} -Ilib bin/rspec spec || die "Tests failed."
}

all_ruby_install() {
	all_fakegem_install

	ruby_fakegem_binwrapper rspec /usr/bin/rspec-3 'gem "rspec", "~>3.0"'
}
