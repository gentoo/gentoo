# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README"

#RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A multipart parser written in Ruby"
HOMEPAGE="https://github.com/danabr/multipart-parser"
#SRC_URI="https://github.com/lostisland/faraday-multipart/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

PATCHES=( "${FILESDIR}"/${P}-fix-tests.patch )
