# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRAINSTALL="data"

RUBY_FAKEGEM_GEMSPEC="unicode-emoji.gemspec"

inherit ruby-fakegem

EMOJI_VERSION=16.0

DESCRIPTION="Up-to-date Emoji Regex and Data in Ruby"
HOMEPAGE="https://github.com/janlelis/unicode-emoji"
SRC_URI="https://github.com/janlelis/unicode-emoji/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://www.unicode.org/Public/emoji/${EMOJI_VERSION}/emoji-test.txt -> ${P}-emoji-test.txt )"
LICENSE="MIT"

SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64"

all_ruby_prepare() {
	if use test; then
		cp "${DISTDIR}/${P}-emoji-test.txt" spec/data/emoji-test.txt || die
	fi
}

each_ruby_test() {
	for spec in spec/*_spec.rb; do
		${RUBY} ${spec} || die
	done
}
