# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

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

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc64 ~x86"
SLOT="4"
IUSE=""
