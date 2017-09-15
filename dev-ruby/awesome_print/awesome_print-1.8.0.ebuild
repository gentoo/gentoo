# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Library to pretty print Ruby objects in full color with proper indentation"
HOMEPAGE="https://github.com/awesome-print/awesome_print"
SRC_URI="https://github.com/awesome-print/awesome_print/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"

KEYWORDS="~alpha ~amd64 ~hppa ~ppc64 ~x86 ~x86-fbsd"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? (
	dev-ruby/nokogiri
)"

all_ruby_prepare() {
	sed -i -e '/codeclimate/I s:^:#:' \
		-e '/simplecov/I s:^:#:' \
		spec/spec_helper.rb || die

	# Avoid activerecord specs since they don't run 
	# consistently accross rails versions and not all 
	# arches have rails
	rm -f spec/ext/active_record_spec.rb || die
}
