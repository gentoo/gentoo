# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

# Upstream has specs but they are not released and upstream is not tagged
RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Ruby Exploitation(Rex) library for generating Random identifier strings"
HOMEPAGE="https://rubygems.org/gems/rex-random_identifier"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_bdepend "dev-ruby/rex-text"
