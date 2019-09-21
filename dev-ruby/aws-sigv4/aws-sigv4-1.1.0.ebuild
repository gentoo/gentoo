# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Amazon Web Services Signature Version 4 signing library"
HOMEPAGE="https://aws.amazon.com/sdk-for-ruby/"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/aws-eventstream-1.0.2:1"
