# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Common protocol buffer types used by Google APIs"
HOMEPAGE="https://github.com/googleapis/common-protos-ruby"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64"

ruby_add_rdepend "
	>=dev-ruby/google-protobuf-3.18:3
"
