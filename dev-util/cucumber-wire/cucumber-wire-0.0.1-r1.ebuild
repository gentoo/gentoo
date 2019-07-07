# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Executable feature scenarios"
HOMEPAGE="https://github.com/aslakhellesoy/cucumber/wikis"
LICENSE="Ruby"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 s390 sparc x86"
SLOT="0"
IUSE="test"

ruby_add_bdepend "test? ( dev-util/cucumber )"
