# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="scanf.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Ruby implementation of the C function scanf(3)"
HOMEPAGE="https://github.com/ruby/scanf"
SRC_URI="https://github.com/ruby/scanf/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"
