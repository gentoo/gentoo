# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Internal HashiCorp service to check version information"
HOMEPAGE="https://www.hashicorp.com"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_bdepend "
	test? ( dev-ruby/rspec-its )
"
