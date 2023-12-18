# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="mini_mime.gemspec"

inherit ruby-fakegem

DESCRIPTION="A lightweight mime type lookup toy"
HOMEPAGE="https://github.com/discourse/mini_mime"
SRC_URI="https://github.com/discourse/mini_mime/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid comparison with MIME::Types because types may vary over time
	# as they get reclassified leading to random harmless failures.
	sed -i -e '/test_full_parity_with_mime_types/askip "gentoo"' test/mini_mime_test.rb || die
}
