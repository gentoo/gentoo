# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="README.md TODO CONTRIBUTING.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Deep Freeze Ruby Objects"
HOMEPAGE="https://rubygems.org/gems/ice_nine https://github.com/dkubb/ice_nine"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~sparc"
IUSE=""

RESTRICT="test"
