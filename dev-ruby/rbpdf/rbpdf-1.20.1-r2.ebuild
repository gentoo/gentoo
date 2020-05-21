# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

# Avoid the complexity of the "rake" recipe and run the tests manually.
RUBY_FAKEGEM_RECIPE_TEST=none

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Ruby on Rails RBPDF plugin"
HOMEPAGE="https://github.com/naitoh/rbpdf"
SRC_URI="https://github.com/naitoh/rbpdf/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

ruby_add_bdepend "test? ( >=dev-ruby/test-unit-3 )"
ruby_add_rdepend "
	dev-ruby/actionview
	dev-ruby/htmlentities
	=dev-ruby/rbpdf-font-1.19*
	|| ( dev-ruby/mini_magick dev-ruby/rmagick )
"

all_ruby_prepare() {
	default

	# This test is enabled automagically in the presence of rmagick, and
	# then fails.
	rm -f test/rbpdf_image_rmagick_test.rb \
		|| die "failed to remove rmagick tests"
}

each_ruby_test() {
	local cmd='gem "test-unit", ">= 3.0"'
	cmd+=' and '
	cmd+='require "test/unit"'
	cmd+=' and '
	cmd+='Dir["test/rbpdf_*.rb"].each{|f| require("./" +  f)}'
	${RUBY} -Ilib:.:test -e "${cmd}" || die "test suite failed"
}
