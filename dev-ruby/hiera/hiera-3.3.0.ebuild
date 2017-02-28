# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A simple pluggable Hierarchical Database"
HOMEPAGE="https://docs.puppet.com/hiera/latest/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~hppa ~x86"

ruby_add_bdepend "test? ( dev-ruby/mocha )"

ruby_add_rdepend "dev-ruby/deep_merge"
