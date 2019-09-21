# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="a simpler alternative to Regular Expressions"
HOMEPAGE="https://github.com/cucumber/cucumber-expressions-ruby#readme"
LICENSE="MIT"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 s390 sparc x86"
SLOT="6.0"
