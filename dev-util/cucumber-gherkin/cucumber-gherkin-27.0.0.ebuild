# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

# Don't install support scripts to avoid slot collisions.
RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="cucumber-gherkin.gemspec"

inherit ruby-fakegem

DESCRIPTION="Fast Gherkin lexer and parser"
HOMEPAGE="https://cucumber.io/"
SRC_URI="https://github.com/cucumber/gherkin/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="gherkin-${PV}/ruby"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~s390 ~sparc ~x86"
SLOT="$(ver_cut 1)"
IUSE=""

ruby_add_rdepend "dev-util/cucumber-messages:22"
