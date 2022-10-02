# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Behaviour Driven Development (BDD) framework for Ruby"
HOMEPAGE="https://github.com/rspec/rspec-support"
SRC_URI="https://github.com/rspec/${PN}/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/rspec-3.9.0:3 >=dev-ruby/thread_order-1.1.0 )"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Remove spec that, by following symlinks, tries to scan pretty much
	# the whole filesystem.
	rm spec/rspec/support/caller_filter_spec.rb || die

	# Avoid spec that requires a dependency on git
	sed -i -e '/library wide checks/,/]/ s:^:#:' spec/rspec/support_spec.rb || die

	# Avoid a spec requiring a specific locale
	sed -i -e '/copes with encoded strings/ s/RSpec::Support::OS.windows?/true/' spec/rspec/support/differ_spec.rb || die

	# Avoid a brittle spec depending on ruby implementation details
	# should be fixed upstream in next version
	#sed -i -e '/returns a hash containing nodes for each line number/askip "ruby26"' spec/rspec/support/source_spec.rb || die
}

each_ruby_prepare() {
	# Use the ruby version being tested
	sed -i -e '/shell_out/ s:ruby:'${RUBY}':' spec/rspec/support/spec/shell_out_spec.rb || die

	case ${RUBY} in
		*ruby31)
			# Avoid specs failing when run in Gentoo, possibly due to different IO
			sed -e '/outputs unified diff message of two arrays/askip "ruby31 IO"' \
				-e '/outputs unified diff message for hashes inside arrays with differing key orders/askip "ruby31 IO"' \
			    -i spec/rspec/support/differ_spec.rb || die
			;;
	esac
}

each_ruby_test() {
	RUBYLIB=lib ${RUBY} -S rspec spec || die
}
