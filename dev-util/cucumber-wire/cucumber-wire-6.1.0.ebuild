# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Executable feature scenarios"
HOMEPAGE="https://cucumber.io/"
LICENSE="Ruby"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv"
SLOT="$(ver_cut 1)"
IUSE="test"

ruby_add_rdepend "
	>=dev-util/cucumber-core-10.0.1:10
	>=dev-util/cucumber-cucumber-expressions-12.1.1:12
	>=dev-util/cucumber-messages-17.0.1:17
"

ruby_add_bdepend "test? ( dev-util/cucumber )"
