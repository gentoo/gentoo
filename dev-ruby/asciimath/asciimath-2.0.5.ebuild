# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.adoc README.adoc"

inherit ruby-fakegem

DESCRIPTION="A pure Ruby AsciiMath parsing and conversion library"
HOMEPAGE="https://github.com/asciidoctor/asciimath"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/nokogiri )"
