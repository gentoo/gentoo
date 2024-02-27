# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Small class for handling filesizes with both the SI and binary prefixes"
HOMEPAGE="https://github.com/dominikh/filesize"

LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~x86"
