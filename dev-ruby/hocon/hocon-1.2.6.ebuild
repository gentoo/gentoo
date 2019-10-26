# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_BINWRAP="hocon"

RUBY_FAKEGEM_GEMSPEC="hocon.gemspec"

inherit ruby-fakegem

DESCRIPTION="This is a port of the Typesafe Config library to Ruby."
HOMEPAGE="https://github.com/puppetlabs/ruby-hocon"
SRC_URI="https://github.com/puppetlabs/ruby-hocon/archive/${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="ruby-hocon-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
