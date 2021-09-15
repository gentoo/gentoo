# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="An RFC2629 (XML2RFC) backend for Thomas Leitner's kramdown markdown parser"
HOMEPAGE="https://github.com/cabo/kramdown-rfc2629"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_rdepend "
	>=dev-ruby/kramdown-2.3.0
	>=dev-ruby/certified-1.0.0
	>=dev-ruby/json-2.0.0
"

all_ruby_prepare() {
	sed -i 's/json_pure/json/' ../metadata || die
}
