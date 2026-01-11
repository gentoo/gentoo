# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

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

ruby_add_bdepend "test? ( >=dev-ruby/test-unit-3 dev-ruby/webrick )"
ruby_add_rdepend "
	dev-ruby/actionview
	dev-ruby/htmlentities
	=dev-ruby/rbpdf-font-1.19*
	|| (
		(
			dev-ruby/marcel
			dev-ruby/mini_magick:5
		)
		dev-ruby/rmagick
	)
"

# Two of the tests require png/jpeg support in "magick identify",
# see bug 738784.
BDEPEND+=" test? ( virtual/imagemagick-tools[jpeg,png] )"

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
	cmd+='gem "mini_magick", "~>5.0"'
	cmd+=' and '
	cmd+='require "test/unit"'
	cmd+=' and '
	cmd+='Dir["test/rbpdf_*.rb"].each{|f| require("./" +  f)}'
	${RUBY} -Ilib:.:test -e "${cmd}" || die "test suite failed"
}
