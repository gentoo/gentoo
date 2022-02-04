# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.adoc README.adoc"

inherit ruby-fakegem

DESCRIPTION="A pure Ruby AsciiMath parsing and conversion library"
HOMEPAGE="https://github.com/pepijnve/asciimath"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/nokogiri )"
