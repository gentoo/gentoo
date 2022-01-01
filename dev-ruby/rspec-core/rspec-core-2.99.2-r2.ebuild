# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_TEST="none"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

# Also install this custom path since internal paths depend on it.
RUBY_FAKEGEM_EXTRAINSTALL="exe"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="rspec-core.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Behaviour Driven Development (BDD) framework for Ruby"
HOMEPAGE="https://github.com/rspec/rspec-core"
SRC_URI="https://github.com/rspec/${PN}/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 hppa ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? (
		>=dev-ruby/nokogiri-1.5.2
		dev-ruby/syntax
		>=dev-ruby/rspec-expectations-2.14.0:2
		>=dev-ruby/rspec-mocks-2.99.0:2
		dev-ruby/rspec:2
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
	sed -i -e '/git ls-files/ s:^:#:' rspec-core.gemspec || die

	# Avoid aruba dependency so that we don't end up in dependency hell.
	sed -i -e '/aruba/ s:^:#:' -e '/Aruba/,/}/ s:^:#:' spec/spec_helper.rb || die
	rm spec/command_line/order_spec.rb || die

	# Avoid testing issues with rspec 3 installed
	sed -i -e '2igem "rspec", "~> 2.0"' bin/rspec || die

	# Remove minor functionality to remain compatible with rake 12
	sed -i -e '/last_comment/ s:^:#:' lib/rspec/core/rake_task.rb || die

	# Avoid autotest specs since this is no longer part of zentest
	sed -i -e '/autotest/ s:^:#:' spec/spec_helper.rb || die
	rm -rf spec/autotest || die
}

each_ruby_prepare() {
	sed -i -e 's:ruby -e:'${RUBY}' -e:' spec/rspec/core_spec.rb || die

	case ${RUBY} in
		*ruby24)
			sed -i -e 's/SAFE = 3/SAFE = 1/' spec/support/helper_methods.rb || die
			sed -i -e 's/Fixnum: 4/Integer: 4/' spec/rspec/core/memoized_helpers_spec.rb || die
			sed -i -e '/warns when HOME env var is not set/,/^  end/ s:^:#:' spec/rspec/core/configuration_options_spec.rb || die
			;;
		*ruby25)
			sed -i -e 's/SAFE = 3/SAFE = 1/' spec/support/helper_methods.rb || die
			sed -i -e 's/Fixnum: 4/Integer: 4/' spec/rspec/core/memoized_helpers_spec.rb || die
			sed -i -e '/warns when HOME env var is not set/,/^  end/ s:^:#:' spec/rspec/core/configuration_options_spec.rb || die
			sed -i -e '/with mathn loaded/,/^          end/ s:^:#:' spec/rspec/core/formatters/html_formatter_spec.rb || die
			sed -i -e '/with mathn loaded/,/^    end/ s:^:#:' spec/rspec/core/formatters/helpers_spec.rb || die
			sed -i -e '/is still a private method/,/end/ s:^:#:' spec/rspec/core/memoized_helpers_spec.rb || die
			sed -i -e '/leaves a raised exception unmodified/,/^      end/ s:^:#:' spec/rspec/core/example_spec.rb || die
			;;
		*ruby26)
			sed -i -e 's/SAFE = 3/SAFE = 0/' spec/support/helper_methods.rb || die
			sed -i -e 's/Fixnum: 4/Integer: 4/' spec/rspec/core/memoized_helpers_spec.rb || die
			sed -i -e '/warns when HOME env var is not set/,/^  end/ s:^:#:' spec/rspec/core/configuration_options_spec.rb || die
			sed -i -e '/with mathn loaded/,/^          end/ s:^:#:' spec/rspec/core/formatters/html_formatter_spec.rb || die
			sed -i -e '/with mathn loaded/,/^    end/ s:^:#:' spec/rspec/core/formatters/helpers_spec.rb || die
			sed -i -e '/is still a private method/,/end/ s:^:#:' spec/rspec/core/memoized_helpers_spec.rb || die
			sed -i -e '/leaves a raised exception unmodified/,/^      end/ s:^:#:' spec/rspec/core/example_spec.rb || die
			;;
		*ruby27)
			sed -i -e 's/SAFE = 3/SAFE = 0/' spec/support/helper_methods.rb || die
			sed -i -e 's/Fixnum: 4/Integer: 4/' spec/rspec/core/memoized_helpers_spec.rb || die
			sed -i -e '/warns when HOME env var is not set/,/^  end/ s:^:#:' spec/rspec/core/configuration_options_spec.rb || die
			sed -i -e '/with mathn loaded/,/^          end/ s:^:#:' spec/rspec/core/formatters/html_formatter_spec.rb || die
			sed -i -e '/with mathn loaded/,/^    end/ s:^:#:' spec/rspec/core/formatters/helpers_spec.rb || die
			sed -i -e '/is still a private method/,/end/ s:^:#:' spec/rspec/core/memoized_helpers_spec.rb || die
			sed -i -e '/leaves a raised exception unmodified/,/^      end/ s:^:#:' spec/rspec/core/example_spec.rb || die
			sed -i -e '/PROC_HEX_NUMBER =/ s/@//' lib/rspec/core/filter_manager.rb || die
			;;
	esac
}

each_ruby_test() {
	PATH="${S}/bin:${PATH}" RUBYLIB="${S}/lib" ${RUBY} -Ilib bin/rspec spec || die "Tests failed."
}

all_ruby_install() {
	all_fakegem_install

	ruby_fakegem_binwrapper rspec /usr/bin/rspec-2 'gem "rspec", "~>2.0"'
}
