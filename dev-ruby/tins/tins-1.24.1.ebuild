# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="All the stuff that isn't good enough for a real library"
HOMEPAGE="https://github.com/flori/tins"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

# Earlier versions of ruby bundled this dependency
USE_RUBY="ruby26 ruby27" ruby_add_rdepend "dev-ruby/sync"

ruby_add_bdepend "test? ( >=dev-ruby/test-unit-2.5.1-r1 )"

each_ruby_prepare() {
	case ${RUBY} in
		*ruby24|*ruby25)
			sed -i -e '/sync/d' ${RUBY_FAKEGEM_GEMSPEC} || die
			;;
	esac
}

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib tests/*_test.rb
}
