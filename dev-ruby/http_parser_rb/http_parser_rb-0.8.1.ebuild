# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_NAME="http_parser.rb"

RUBY_FAKEGEM_EXTENSIONS=(ext/ruby_http_parser/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Simple callback-based HTTP request/response parser"
HOMEPAGE="https://github.com/tmm1/http_parser.rb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
