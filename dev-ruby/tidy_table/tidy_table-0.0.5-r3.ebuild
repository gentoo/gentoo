# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/tidy_table/tidy_table-0.0.5-r3.ebuild,v 1.7 2015/04/14 07:06:26 ago Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="Tool to convert an array of struct into an HTML table"
HOMEPAGE="https://github.com/topfunky/tidy_table"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

ruby_add_bdepend "doc? ( dev-ruby/hoe )"

all_ruby_prepare() {
	# Remove reference to RSpec 1
	sed -i -e '/spec/d' spec/spec_helper.rb || die
}
