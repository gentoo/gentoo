# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Common gRPC and protocol buffer classes used in Google APIs"
HOMEPAGE="https://github.com/googleapis/common-protos-ruby"
SRC_URI="https://github.com/googleapis/common-protos-ruby/archive/${PN}/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="common-protos-ruby-${PN}-v${PV}/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=net-libs/grpc-1.27"
BDEPEND=""

ruby_add_rdepend "
	>=dev-ruby/google-protobuf-3.14
	>=dev-ruby/googleapis-common-protos-types-1.2
"
