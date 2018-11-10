# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Protocol Buffer messages for Cucumber's inter-process communication"
HOMEPAGE="https://github.com/cucumber/cucumber-messages-ruby#readme"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="2.0"

ruby_add_rdepend "~dev-ruby/google-protobuf-3.6.1"
