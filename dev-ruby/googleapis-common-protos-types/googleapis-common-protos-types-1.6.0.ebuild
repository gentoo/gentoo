# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Ruby protocol buffer classes generated from googleapis repository"
HOMEPAGE="https://github.com/googleapis/api-common-protos"
SRC_URI="https://github.com/googleapis/common-protos-ruby/archive/${PN}/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="common-protos-ruby-googleapis-common-protos-types-v${PV}/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-ruby/google-protobuf-3.14"
