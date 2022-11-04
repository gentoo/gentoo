# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md"
RUBY_FAKEGEM_EXTRAINSTALL="VERSION"

inherit ruby-fakegem

DESCRIPTION="Amazon Web Services Signature Version 4 signing library"
HOMEPAGE="https://aws.amazon.com/sdk-for-ruby/"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~amd64 ~arm64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/aws-eventstream-1.0.2:1"
