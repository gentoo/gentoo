# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

RUBY_FAKEGEM_NAME="Ascii85"

inherit ruby-fakegem

DESCRIPTION="Methods for encoding/decoding Adobe's binary-to-text encoding of the same name"
HOMEPAGE="https://github.com/datawraith/ascii85gem"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

ruby_add_rdepend "!<dev-ruby/ascii85-1.1.1-r1"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die
}
