# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23"
#RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Ruby Exploitation(Rex) library gem for reading/writing OLE files and streams"
HOMEPAGE="https://rubygems.org/gems/rex-ole"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

# doesn't seem to actually run any tests
RESTRICT=test

ruby_add_bdepend "dev-ruby/rex-text"
