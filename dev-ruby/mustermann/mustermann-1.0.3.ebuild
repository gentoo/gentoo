# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

# There are specs but they depend heavily on unpackaged code.
RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A library implementing patterns that behave like regular expressions"
HOMEPAGE="https://github.com/sinatra/mustermann"

LICENSE="MIT"
SLOT="1"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""
