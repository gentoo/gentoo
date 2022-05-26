# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_TEST="test_units"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A pure ruby implementation of Remi Coulom's Whole-History Rating algorithm"
HOMEPAGE="https://github.com/goshrine/whole_history_rating"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "dev-ruby/matrix"

ruby_add_bdepend "
	test? (
		dev-ruby/test-unit:2
	)
"
