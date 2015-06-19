# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/dotenv/dotenv-1.0.2.ebuild,v 1.2 2015/03/20 13:43:41 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="README.md Changelog.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Loads environment variables from .env into ENV"
HOMEPAGE="https://github.com/bkeepers/dotenv"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

each_ruby_prepare() {
	sed -i -e "s:ruby -v:${RUBY} -v:g" spec/dotenv/parser_spec.rb || die
}
