# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

# Not packaged and upstream not tagged.
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Provides API clients for AWS"
HOMEPAGE="https://aws.amazon.com/sdk-for-ruby/"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="~amd64 ~arm64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/aws-eventstream-1.0.2:1"
ruby_add_rdepend ">=dev-ruby/aws-partitions-1.239.0:1"
ruby_add_rdepend ">=dev-ruby/aws-sigv4-1.1:1"
ruby_add_rdepend "dev-ruby/jmespath:1"
