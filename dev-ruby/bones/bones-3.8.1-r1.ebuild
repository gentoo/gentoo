# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

RUBY_FAKEGEM_EXTRAINSTALL="default version.txt"

inherit ruby-fakegem

DESCRIPTION="Tool that creates new Ruby projects from a code skeleton"
HOMEPAGE="https://github.com/TwP/bones"

IUSE="test"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend "
	dev-ruby/builder
	>=dev-ruby/loquacious-1.9.1
	>=dev-ruby/little-plugger-1.1.3
	>=dev-ruby/rake-0.8.7"

all_ruby_prepare() {
	epatch "${FILESDIR}"/${P}-builder.patch
	mv ../metadata .
	epatch "${FILESDIR}"/${P}-rdoc-version.patch
	mv metadata ../
}
