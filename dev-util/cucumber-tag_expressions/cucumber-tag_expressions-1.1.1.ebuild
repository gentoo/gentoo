# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Cucumber tag expressions for ruby"
HOMEPAGE="https://docs.cucumber.io/tag-expressions/"
LICENSE="MIT"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~s390 sparc x86"
SLOT="1"
