# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

# There are specs but they depend heavily on unpackaged code.
RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A library implementing patterns that behave like regular expressions"
HOMEPAGE="https://github.com/sinatra/mustermann"

LICENSE="MIT"
SLOT="1"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

ruby_add_rdepend "=dev-ruby/ruby2_keywords-0.0*"
