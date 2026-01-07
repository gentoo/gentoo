# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Markup as Ruby"
HOMEPAGE="https://github.com/camping/mab"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest )"
