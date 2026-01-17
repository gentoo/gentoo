# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Minitest + all the features you always wanted"
HOMEPAGE="https://github.com/grosser/maxitest"
SRC_URI="https://github.com/grosser/maxitest/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/minitest-5.20.0:* <dev-ruby/minitest-5.28.0:*"

ruby_add_bdepend "test? ( dev-ruby/bundler >=dev-ruby/minitest-5.21.0 )"

all_ruby_prepare() {
	rm -f Gemfile.lock || die
	# Remove developer-only gems from the gemspec and avoid git issues
	sed -e 's:_relative ": "./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -e '/\(debug\|bump\)/ s:^:#:' \
		-i Gemfile || die

	sed -e '/shows backtrace for/askip' \
		-e '/describe.*line/ s/describe/xdescribe/' \
		-e '/describe.*color/ s/describe/xdescribe/' \
		-i spec/maxitest_spec.rb || die
}

each_ruby_prepare() {
	# Use the correct target
	sed -e '/\(run_cmd\|sh\)/ s:ruby :'${RUBY}' :' \
		-e '/\(run_cmd\|sh\)/ s:mtest:'${RUBY}' -rmaxitest/version -S bin/mtest:' \
		-i spec/maxitest_spec.rb || die

	case ${RUBY} in
		*ruby34)
			# Avoid test failing due to changed messages in Ruby.
			sed -e '/stops on ctrl+c and prints errors/ s/it/xit/' \
				-e '/shows backtraces when in verbose mode/ s/it/xit/' \
				-i spec/maxitest_spec.rb || die
			;;
	esac
}

each_ruby_test() {
	PATH="${S}/bin:${PATH}" RUBYLIB="${S}/lib" RSPEC_VERSION=3 ruby-ng_rspec spec
}
