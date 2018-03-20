# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

# Don't install support scripts to avoid slot collisions.
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Fast Gherkin lexer and parser"
HOMEPAGE="https://github.com/cucumber/gherkin"
LICENSE="MIT"

KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ia64 ppc ppc64 sparc x86"
SLOT="4"
IUSE=""
