# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="README.rdoc"
RUBY_FAKEGEM_GEMSPEC="stream.gemspec"

inherit ruby-fakegem

DESCRIPTION="Module Stream defines an interface for external iterators"
HOMEPAGE="https://github.com/monora/stream"
SRC_URI="https://github.com/monora/stream/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "dev-ruby/bundler dev-ruby/yard test? ( dev-ruby/test-unit )"
