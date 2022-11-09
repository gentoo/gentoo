# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="CHANGES EXPRESSIONS.md README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="An abstraction and a framework for compiling templates to pure Ruby"
HOMEPAGE="https://github.com/judofyr/temple"

LICENSE="MIT"
SLOT="0.7"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"
IUSE=""

ruby_add_bdepend "test? (
	dev-ruby/erubis
	>=dev-ruby/tilt-2.0.1 )"
