# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md History.txt"

RUBY_FAKEGEM_NAME="Ascii85"

inherit ruby-fakegem

DESCRIPTION="Methods for encoding/decoding Adobe's binary-to-text encoding of the same name"
HOMEPAGE="https://github.com/datawraith/ascii85gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die
}
