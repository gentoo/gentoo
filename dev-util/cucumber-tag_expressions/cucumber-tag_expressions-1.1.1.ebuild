# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Cucumber tag expressions for ruby"
HOMEPAGE="https://docs.cucumber.io/tag-expressions/"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~sparc ~x86"
SLOT="1"
