# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

inherit ruby-fakegem

DESCRIPTION="Library that provides memoziation for methods and functions for Ruby"
HOMEPAGE="https://github.com/flori/mize"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
