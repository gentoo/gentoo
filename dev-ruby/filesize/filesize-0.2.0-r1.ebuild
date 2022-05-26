# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="small ruby class for handling filesizes with both the SI and binary prefixes"
HOMEPAGE="https://github.com/dominikh/filesize"

LICENSE="MIT"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
