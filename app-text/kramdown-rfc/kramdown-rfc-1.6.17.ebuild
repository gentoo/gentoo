# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27"

# The software got renamed from kramdown-rfc2629 to kramdown-rfc,
# however the gem coordinate is still kramdown-rfc2629.
RUBY_FAKEGEM_NAME="${PN}2629"
RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="An XML2RFC (RFC799x) backend for Thomas Leitner's kramdown markdown parser"
HOMEPAGE="https://github.com/cabo/kramdown-rfc"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

ruby_add_rdepend "
	>=dev-ruby/certified-1.0.0
	>=dev-ruby/json-2.0.0
	>=dev-ruby/kramdown-2.4.0
	>=dev-ruby/kramdown-parser-gfm-1.1.0
"

all_ruby_prepare() {
	sed -i 's/json_pure/json/' ../metadata || die
}
