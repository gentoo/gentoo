# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.markdown"
RUBY_FAKEGEM_GEMSPEC="rainbow.gemspec"

inherit ruby-fakegem

DESCRIPTION="Colorize printed text on ANSI terminals"
HOMEPAGE="https://github.com/sickill/rainbow"

SRC_URI="https://github.com/sickill/rainbow/archive/v${PV}.tar.gz -> ${PN}-git-${PV}.tgz"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""
