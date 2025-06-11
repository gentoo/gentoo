# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

# The software got renamed from kramdown-rfc2629 to kramdown-rfc,
# however the gem coordinate is still kramdown-rfc2629.
RUBY_FAKEGEM_NAME="${PN}2629"
RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_EXTRAINSTALL="data"
# Explicitly use the gemspec file over the metadata file of the gem, as
# the latter contains dependencies that we patched out.
RUBY_FAKEGEM_GEMSPEC="${RUBY_FAKEGEM_NAME}.gemspec"

inherit ruby-fakegem

DESCRIPTION="An XML2RFC (RFC799x) backend for Thomas Leitner's kramdown markdown parser"
HOMEPAGE="https://github.com/cabo/kramdown-rfc"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.27-Drop-dependency-on-certified.patch
	"${FILESDIR}"/${PN}-1.7.22-remove-bin-echars.patch
)

ruby_add_rdepend "
	>=dev-ruby/json-2.0.0
	>=dev-ruby/kramdown-2.4.0
	>=dev-ruby/kramdown-parser-gfm-1.1.0
	>=dev-ruby/net-http-persistent-4.0
"

all_ruby_prepare() {
	sed -i 's/json_pure/json/' "${RUBY_FAKEGEM_GEMSPEC}" || die
}
