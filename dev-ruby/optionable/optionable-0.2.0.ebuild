# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Robust options validation for Ruby methods"
HOMEPAGE="https://github.com/durran/optionable"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
