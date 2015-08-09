# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Default pagination generator for Jekyll"
HOMEPAGE="https://github.com/jekyll/jekyll-paginate"
SRC_URI="https://github.com/jekyll/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( >=www-apps/jekyll-2 )"

all_ruby_prepare() {
	rm Rakefile || die
	sed -i -e "s/truthy/true/" -e "s/falsey/false/" spec/pager_spec.rb || die
	# Remove unkown options until Rspec3 is in tree
	sed -i -e "/expectations.include_chain_clauses_in_custom_matcher_descriptions/d"\
		-e "/verify_partial_doubles/d" -e "/disable_monkey_patching!/d"  spec/spec_helper.rb || die
}
