# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23"

RUBY_FAKEGEM_EXTRADOC="README"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="Base class with almost all of the methods from Object and Kernel being removed"
HOMEPAGE="https://rubygems.org/gems/blankslate"

IUSE=""
LICENSE="MIT"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~x86 ~ppc ~ppc64"

RESTRICT="test"
