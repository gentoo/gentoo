# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Protocol Buffer messages for Cucumber's inter-process communication"
HOMEPAGE="https://github.com/cucumber/cucumber-messages-ruby#readme"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="$(ver_cut 1)"

ruby_add_rdepend "<dev-ruby/google-protobuf-3.9"
