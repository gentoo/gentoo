# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Module that provides Gem based plugin management"
HOMEPAGE="https://github.com/TwP/little-plugger"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
